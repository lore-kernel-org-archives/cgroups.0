From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: [RFC 0/4] cgroup hierarchy controls and stats
Date: Wed, 2 Aug 2017 17:55:28 +0100
Message-ID: <20170802165532.22277-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=4/oPEwYBXtq1YS3dGdaj5wiFjymFzMuje1cnXCNHLmE=;
 b=rfuOPUo9DKgjwaHIgiG1/wqrjGe07OC2Tn6yE03v1H1jiBwghfzw9/dviRYoJGdDsewE
 oaEIj1LIGomeSKOLgim8JCeueazK1CDY9FYPZ+1zCsQPZDxfm4TPQp9/aS2q8DzJ0vOR
 K+FCixr4HnACWva7pcwbWfM2chMADpDGBDo= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=4/oPEwYBXtq1YS3dGdaj5wiFjymFzMuje1cnXCNHLmE=;
 b=PUGhHYUMkjwQB8sNQifyfIqZmluf1ZZaI9JIPG5fB0mWOTaHe8VfdGhYSwFd3775zsra10mpflovQ0bS2RbiovO8fgyV2WhR4kIOT0vFQ+KjO0aXR9uT9xwFx1/zwwg0Fwssmjo5oJVztmnZ3stdJv+lpsXj0hJPPqwLTj10tqw=
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Creating cgroup hierearchies of an unreasonable size can affect
system performance. A user might want to limit the size
of the cgroup hierarchy.

This patchset implements an ability to control and monitor cgroup
hierarchy size.

Patch 1 implements tracking of live and dying descendant cgroups
        on each cgroup level.
Patch 2 adds cgroup.max.descendants and cgroup.max.depth interfaces
        to set up hierarchy limits.
Patch 3 adds cgroup.stat interface with simple hierarchy stats.
Patch 4 is a trivial cleanup.

Roman Gushchin (4):
  cgroup: keep track of number of descent cgroups
  cgroup: implement hierarchy limits
  cgroup: add cgroup.stat interface with basic hierarchy stats
  cgroup: re-use the parent pointer in cgroup_destroy_locked()

 Documentation/cgroup-v2.txt |  32 +++++++++
 include/linux/cgroup-defs.h |  13 ++++
 kernel/cgroup/cgroup.c      | 163 +++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 205 insertions(+), 3 deletions(-)

--
2.13.3
