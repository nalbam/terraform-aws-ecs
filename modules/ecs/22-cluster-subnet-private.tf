# subnet private

resource "aws_subnet" "private" {
  count      = "${local.az_count}"
  vpc_id     = "${data.aws_vpc.cluster.id}"
  cidr_block = "${cidrsubnet(data.aws_vpc.cluster.cidr_block, 2, (count.index + 1))}" // /18 64 C 16384 255.255.192.000

  availability_zone = "${data.aws_availability_zones.azs.names[count.index]}"

  tags = {
    Name = "${var.city}-${upper(element(split("", data.aws_availability_zones.azs.names[count.index]), length(data.aws_availability_zones.azs.names[count.index])-1))}-${var.stage}-${var.name}-${var.suffix}-PRIVATE"
  }
}

resource "aws_eip" "private" {
  count      = "${local.az_count}"
  vpc        = true
  depends_on = ["aws_route_table.public"]

  tags = {
    Name = "${var.city}-${upper(element(split("", data.aws_availability_zones.azs.names[count.index]), length(data.aws_availability_zones.azs.names[count.index])-1))}-${var.stage}-${var.name}-${var.suffix}-PRIVATE"
  }
}

resource "aws_nat_gateway" "private" {
  count         = "${local.az_count}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  allocation_id = "${element(aws_eip.private.*.id, count.index)}"
}

resource "aws_route_table" "private" {
  count  = "${local.az_count}"
  vpc_id = "${data.aws_vpc.cluster.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${element(aws_nat_gateway.private.*.id, count.index)}"
  }

  tags = {
    Name = "${var.city}-${upper(element(split("", data.aws_availability_zones.azs.names[count.index]), length(data.aws_availability_zones.azs.names[count.index])-1))}-${var.stage}-${var.name}-${var.suffix}-PRIVATE"
  }
}

resource "aws_route_table_association" "private" {
  count          = "${local.az_count}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}
