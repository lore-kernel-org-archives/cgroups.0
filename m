From: =?UTF-8?Q?Gra=C5=BEvydas_Ignotas?= <notasas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: UDP rx packet loss in a cgroup with a memory limit
Date: Tue, 16 Aug 2022 21:52:26 +0300
Message-ID: <CANOLnON11vzvVdyJfW+QJ36siWR4-s=HJ2aRKpRy7CP=aRPoSw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc;
        bh=5gMKQRpWDdjEmS+r2aL9i2O5+nVG9o/r7VVu0SGzm1M=;
        b=gRI3uuMxxiAxi1hxTP+k3wTpq6aRMob4XanAQsZSMxCBW8hjOB310VMxwDyi36XNUA
         /k7GTPEX7uNTk/rDZ4f2KbkmYjQsRUs7VgXfBLup/aINuc1kzpIU9k0BJpqH32w7vl+r
         T2L7DF2hQg9FZCGAbMp6TfQJDrYQDIEfJQt2sTi0Z7UaXcdYkL8Dki1uhSwQHAKbZv7A
         Aardr6gRqS/qsJ0mtbnQ1GiJkqDnKX+AvA9BQnbCbUHoYh1/XzDLo2aW1KWMwzHsfJEB
         6fTPOTgiexyswIer7EQCw9r8M371D1n87lkeZq2ZumKVLvE3O7kXlxdCWdnQ6dyAqTU6
         0hZw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

I'm unsure if it's supposed to be like this, but I'm seeing this on
various hardware combinations/VMs and Debian kernel versions, plus
self-compiled vanilla 5.19.1 I just tried. It looks like this only
happens on cgroup v2:

Debian11/bullseye (cgroup v2), distro kernel: yes
Debian11/bullseye (cgroup v2), vanilla 5.19.1: yes
Debian10/buster (cgroup v1), bpo kernel: no
Debian10/buster (cgroup v2)*, bpo kernel: yes
* - booted with 'systemd.unified_cgroup_hierarchy=3D1' to enable cgroup v2

Basically, when there is git activity in the container with a memory
limit, other processes in the same container start to suffer (very)
occasional network issues (mostly DNS lookup failures). Git's or other
processes' memory usage doesn't seem to be anywhere close to the
limit. The fact about packet drops can be seen from /proc/net/snmp
"Udp InErrors" counter increasing, as well as "drops" counter
increasing in /proc/net/udp . Some other random details about this:
- stopping git (its disk activity?) makes the packet loss stop
- tcpdump (ran in the container itself) shows packet correctly
arriving without errors, but the process times out waiting for
response
- if memory limit is removed the problem disappears
- if memory limit is set to host's RAM size, the problem disappears
- reducing dirty_ratio, dirty_background_ratio doesn't help

My recipe to reproduce:
- install kubernetes on a host machine with Debian11 and 32GB RAM
- create a debian9 container with 'resources: limits: memory: "8G"'
- in the container:

# run this:
git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
cd linux
while git checkout linux-2.6.32.y && git checkout linux-5.19.y; do true; do=
ne
# at the same time in the same container:
while sleep .1; do host <remotehost>. > /dev/null; awk '/^Udp:
[0-9]/{print $4}' /proc/net/snmp; done

The packet drop counter should start increasing after some time. The
effect is much stronger if the git repository is bigger and has
different multi-gigabyte files in those branches. Can something be
done to avoid this packet loss?

Gra=C5=BEvydas
