From: Daniel Xu <dxu@dxuuu.xyz>
Subject: [PATCH 0/2] Support user xattrs in cgroupfs
Date: Mon,  2 Mar 2020 17:38:59 -0800
Message-ID: <20200303013901.32150-1-dxu@dxuuu.xyz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm2; bh=ysvyyNqelCZVTgBcWzOEvvcC33
        cx9jhu4emdd18b2bk=; b=ZU+Ln5Z7UWVizqx8sTVNu/iUB+0/wVA9ON3/keSvmx
        6qKz93LZGBkkkhXsqYKQVmUgXq3Kx6mLxObp7W0USNaKcxx6ZLs94nRxRvxRJk0b
        wDrYfvhB5Nl6hli4IdzXRTHsAWgd5K5wu6zpIikd9WjLbIgjCY66tu2FAuk5ebcW
        Z/d9Ascb3JCubO9bDhoDRFJLUZBXiQ0+5pgfCAJd1BiYVPEv3B5cN7sz24SaVQqn
        lRn7gzvHqaVUq6ObNKQz23h7BrShEYykLDCAm/ytEhjceRNB62Fgh8nNhnsfVpoF
        BbLCFGZlbFI9uBxLDu4Jf0bUZVJHKMT9D+ApfW6S6o1g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ysvyyNqelCZVTgBcW
        zOEvvcC33cx9jhu4emdd18b2bk=; b=pQ+Z4iPiki3atQvxFQd7Wp1p9TQ0ukQeE
        Nqltpy/aJyklL7PFMEzMqolOTsVTa9PRw5em6tmS+mSpVerlwVzDd/WSEqJetCWA
        T/vMDAaBdCklHQXKBBYJiWgFm9d0xnP806c1b7ZdjNmmFpgZCS2ZQRt4qF4xBDof
        PpzgMnvlxx+XVY/ND+i1h4aI1Mv0z+ideY46KStLp4k8bVQAh/eL9KiJdjecSS3h
        F7c1RpjW4cq8wj76bWq8RM518eQyFo492vTuQPP+HQTG6ghW82+sNLPatQjZFzQD
        vlisC/6lKPFOEbY1t1d79pCa70fqOdd4hSyLxGSvE6/tVXOv4XD4w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org
Cc: Daniel Xu <dxu@dxuuu.xyz>, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, kernel-team@fb.com

User extended attributes are useful as metadata storage for kernfs
consumers like cgroups. Especially in the case of cgroups, it is useful
to have a central metadata store that multiple processes/services can
use to coordinate actions.

A concrete example is for userspace out of memory killers. We want to
let delegated cgroup subtree owners (running as non-root) to be able to
say "please avoid killing this cgroup". In server environments this is
less important as everyone is running as root. But for desktop linux,
this is more important.

The first patch introduces a new flag, KERNFS_ROOT_SUPPORT_USER_XATTR,
that lets kernfs consumers enable user xattr support. The second patch
turns on this feature for cgroupfs.

Daniel Xu (2):
  kernfs: Add option to enable user xattrs
  cgroupfs: Support user xattrs

 fs/kernfs/inode.c           | 47 +++++++++++++++++++++++++++++++++++++
 fs/kernfs/kernfs-internal.h |  1 +
 include/linux/kernfs.h      |  6 +++++
 kernel/cgroup/cgroup.c      |  3 ++-
 4 files changed, 56 insertions(+), 1 deletion(-)

-- 
2.21.1

