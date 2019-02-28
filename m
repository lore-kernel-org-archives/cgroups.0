From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 0/6] mm: memcontrol: clean up the LRU counts tracking
Date: Thu, 28 Feb 2019 16:42:41 +0000
Message-ID: <20190228164236.GA26032@tower.DHCP.thefacebook.com>
References: <20190228163020.24100-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=J3TkBkbgJLidYXQwndc5Y9K0JpBhnEgIwXZ3Hj0Jilw=;
 b=PdTYtuKzCtdu7/AkoHQwy8yoDgjX1G/aw3pkyoiTqNFyEWF+/zR6DaMpw8OUFJSrjwnC
 LNKwDRfDZHucZiqMsJDhYbp1wZHCU1eVmFwh3MhJclXcmAor1cud5lW4HGPiwfS0sAyn
 4Tx/s2xkUHRXkbngn+PUUnwuydZo4Ux+y00= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J3TkBkbgJLidYXQwndc5Y9K0JpBhnEgIwXZ3Hj0Jilw=;
 b=DlU9Iw75/ITd5HVG3W+TNbiB0rOudfHNMirVPZkbVWrNczFMHfCvYMQOumu9bVKPc85t+CnEOcuapGCVsN7y+hiTOJtvXKlUNwauA3z3ywqEGHMud5FmO1CdaBPZG+lVkvysPwjFR8A2C2r/ig9UmRgRUyuPKj2vyaZX8s3PnTU=
In-Reply-To: <20190228163020.24100-1-hannes@cmpxchg.org>
Content-Language: en-US
Content-ID: <FF49BB458586CF448F1935237336EB36@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Thu, Feb 28, 2019 at 11:30:14AM -0500, Johannes Weiner wrote:
> [ Resend #2: Sorry about the spam, I mixed up the header fields in
>   git-send-email and I don't know who did and didn't receive the
>   garbled previous attempt.
>=20
>   Resend #1: Rebased on top of the latest mmots. ]
>=20
> The memcg LRU stats usage is currently a bit messy. Memcg has private
> per-zone counters because reclaim needs zone granularity sometimes,
> but we also have plenty of users that need to awkwardly sum them up to
> node or memcg granularity. Meanwhile the canonical per-memcg vmstats
> do not track the LRU counts (NR_INACTIVE_ANON etc.) as you'd expect.
>=20
> This series enables LRU count tracking in the per-memcg vmstats array
> such that lruvec_page_state() and memcg_page_state() work on the enum
> node_stat_item items for the LRU counters. Then it converts all the
> callers that don't specifically need per-zone numbers over to that.
>=20
>  include/linux/memcontrol.h | 28 ---------------
>  include/linux/mm_inline.h  |  2 +-
>  include/linux/mmzone.h     |  5 ---
>  mm/memcontrol.c            | 85 +++++++++++++++++++++++++---------------=
----
>  mm/vmscan.c                |  2 +-
>  mm/workingset.c            |  5 +--
>  6 files changed, 54 insertions(+), 73 deletions(-)
>=20
>=20


The patchset looks very good to me!

Reviewed-by: Roman Gushchin <guro@fb.com>

Thanks!
