From: yulei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [RFC 0/1] Introduce new attribute "priority" to control group
Date: Sun,  4 Apr 2021 22:51:53 +0800
Message-ID: <cover.1617355387.git.yuleixzhang@tencent.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H5jofbm8j2utH1mZKQBvpAx1voU9P5mgvMVABgwERu0=;
        b=KR8OK7X6eJDauTOYhwmJ2tn8j1RG2NJcqskR+M0/kuHa32tVrtgS8/HMJyMo0FBsz/
         EscfbrHoFM8ckHPBDAV1lHbLH45VXMYe2Kx1AAcCk1BUDb+DhZ+SWfexD5Q9uajJ9lLD
         FI0fCUbRImM+UIEv15Iaw3hvxuksXBEDNTuSsByiyP7+9VA8Wjem3FiFkK+Ouj19JK/Q
         m+NSOXNUk5xBdYYECSMg7qqE5ZzaCkEs9LGqiCMBcPvfYvTv/MkzTRMSuwyn8jTRMh2G
         AXbsqeJaXF+jS0ot0i+pAMNx9Rw43aIvfkw4NIU3OUI3icBRHYETej1ySap1eONzuLZp
         9jMQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, benbjiang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, kernellwp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, lihaiwei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linussli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, herberthbli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, lennychen-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, allanyuliu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

From: Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

This patch is the init patch of a series which we want to present the idea
of prioritized tasks management. As the cloud computing introduces intricate
configurations to provide customized infrasturctures and friendly user
experiences, in order to maximum utilization of sources and improve the
efficiency of arrangement, we add the new attribute "priority" to control
group, which could be used as graded factor by subssystems to manipulate
the behaviors of processes.

Base on the order of priority, we could apply different resource configuration
strategies, sometimes it will be more accuracy instead of fine tuning in each
subsystem. And of course to set fundamental rules, for example, high priority
cgroups could seize the resource from cgroups with lower priority all the time.

The default value of "priority" is set to 0 which means the highest
priority, and the totally levels of priority is defined by
CGROUP_PRIORITY_MAX. Each subsystem could register callback to receive the
priority change notification for their own purposes. 

We would like to send out the corresponding features in the coming weeks,
which are relaying on the priority settings. For example, the prioritized
oom, memory reclaiming and cpu schedule strategy.

Lei Chen (1):
  cgroup: add support for cgroup priority

 include/linux/cgroup-defs.h |  2 +
 include/linux/cgroup.h      |  2 +
 kernel/cgroup/cgroup.c      | 90 +++++++++++++++++++++++++++++++++++++
 3 files changed, 94 insertions(+)

-- 
2.28.0

