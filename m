From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v11 00/16] per memcg lru lock
Date: Mon, 8 Jun 2020 14:13:26 +0800
Message-ID: <31943f08-a8e8-be38-24fb-ab9d25fd96ff@linux.alibaba.com>
References: <1590663658-184131-1-git-send-email-alex.shi@linux.alibaba.com>
 <alpine.LSU.2.11.2006072100390.2001@eggly.anvils>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LSU.2.11.2006072100390.2001-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org



=D4=DA 2020/6/8 =CF=C2=CE=E712:15, Hugh Dickins =D0=B4=B5=C0:
>>  24 files changed, 487 insertions(+), 312 deletions(-)
> Hi Alex,
>=20
> I didn't get to try v10 at all, waited until Johannes's preparatory
> memcg swap cleanup was in mmotm; but I have spent a while thrashing
> this v11, and can happily report that it is much better than v9 etc:
> I believe this memcg lru_lock work will soon be ready for v5.9.
>=20
> I've not yet found any flaw at the swapping end, but fixes are needed
> for isolate_migratepages_block() and mem_cgroup_move_account(): I've
> got a series of 4 fix patches to send you (I guess two to fold into
> existing patches of yours, and two to keep as separate from me).
>=20
> I haven't yet written the patch descriptions, will return to that
> tomorrow.  I expect you will be preparing a v12 rebased on v5.8-rc1
> or v5.8-rc2, and will be able to include these fixes in that.

I am very glad to get your help on this feature!=20

and looking forward for your fixes tomorrow. :)

Thanks a lot!
Alex
