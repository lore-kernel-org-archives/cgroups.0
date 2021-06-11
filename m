From: Kir Kolyshkin <kolyshkin@gmail.com>
Subject: [PATCH 0/3] add/update/fix BFQ docs
Date: Thu, 10 Jun 2021 20:07:34 -0700
Message-ID: <20210611030737.1984343-1-kolyshkin@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cww4YAD4W8e5YtVsLar88kpQ76E3chRpXf1PGNQpk6o=;
        b=CKh9czTQUO98TR4VM0uad4kJNDB2x3J1rSXbP6I44BFYVmJ6GmxdfInEAcbD4BpPOX
         582qg9ZY1jJ6wjehaPMUgl2e5RXTiBwg2Q9oREu6xzi16d9WJTGJZaeZCIa38rsWU4w4
         utJEeCOEX2O0+Kd4iRyO7/vy9auXrQOxKSOnGF5+kyMiaGxe48DS+zAk0pmZbdXavPfN
         Fi2k0UlNBT8HqJu8T0/JoVrY4HPiWp42Wz/qtUZ/N6bcauusj5gYb0YuhVxUhGf9VCDX
         IrZljKbEq/gay+39QXhstMBVlPNIVpKBpZGgTYin/BMHz2m3JPd3iagprl1p831bC3yc
         U8wA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-doc@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>, tj@kernel.org, axboe@kernel.dk, paolo.valente@linaro.org, cgroups@vger.kernel.org, Kir Kolyshkin <kolyshkin@gmail.com>

Improve BFQ docs: fix formatting, adding a missing piece.

Fix cgroup v1 blkio docs which are not updated for CFQ -> BFQ.

Patches are on top of the latest docs-next (commit acda97acb2e98c97895).

Kir Kolyshkin (3):
  docs: block/bfq: describe per-device weight
  docs/cgroup-v1/blkio: stop abusing itemized list
  docs/cgroup-v1/blkio: update for 5.x kernels

 .../cgroup-v1/blkio-controller.rst            | 155 +++++++++---------
 Documentation/block/bfq-iosched.rst           |  38 +++--
 2 files changed, 107 insertions(+), 86 deletions(-)

-- 
2.31.1

