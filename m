From: Qian Cai <cai@lca.pw>
Subject: Re: [PATCH -next] mm/vmscan: fix an undefined behavior for zone id
Date: Tue, 12 Nov 2019 11:24:51 -0500
Message-ID: <1573575891.5937.118.camel@lca.pw>
References: <20191108204407.1435-1-cai@lca.pw>
         <64E60F6F-7582-427B-8DD5-EF97B1656F5A@lca.pw>
         <20191111130516.GA891635@chrisdown.name>
         <20191111131427.GB891635@chrisdown.name>
         <20191111132812.GK1396@dhcp22.suse.cz>
         <20191112145942.GA168812@cmpxchg.org> <20191112152750.GA512@dhcp22.suse.cz>
         <20191112161658.GF168812@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0a/sJJWyyFBbZkhKlYELP0090+55ZSiU8jLaE8NbD5U=;
        b=IhePBCHP1xPWJCnc0fhVuvGX81sL2k6BScL+Bp+yw2KH1UDC3HLFXYBUATgLx+0u3v
         3gpl92D1w8C8IuZpcc5/phnYVF2vimLZtVzNmmL/wOjbKhECk2jAoYWneZ8wLYEXskpx
         zUdNO45Dpq1aJZ271qIBeemjihB+/nrs71YJRPkYTbYpEx0zRFXtV/KwCscC74+ruEmj
         3MfrQbYRs9OTIoMoqQQy9qYXAZ2yMmPdsf5PUHTIwg1W3cnSfXXlOleyhBFUla1Dqq84
         sW88XHmq+3ktVLYs1u9fENB0/RRJoUkltX3Go4MifZFej10ejfv9DlLSbtvIb1raLmKF
         ox6A==
In-Reply-To: <20191112161658.GF168812@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>
Cc: Chris Down <chris@chrisdown.name>, akpm@linux-foundation.org, guro@fb.com, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 2019-11-12 at 11:16 -0500, Johannes Weiner wrote:
> On Tue, Nov 12, 2019 at 04:27:50PM +0100, Michal Hocko wrote:
> > On Tue 12-11-19 06:59:42, Johannes Weiner wrote:
> > > Qian, thanks for the report and the fix.
> > >=20
> > > On Mon, Nov 11, 2019 at 02:28:12PM +0100, Michal Hocko wrote:
> > > > On Mon 11-11-19 13:14:27, Chris Down wrote:
> > > > > Chris Down writes:
> > > > > > Ah, I just saw this in my local checkout and thought it was fro=
m my
> > > > > > changes, until I saw it's also on clean mmots checkout. Thanks =
for the
> > > > > > fixup!
> > > > >=20
> > > > > Also, does this mean we should change callers that may pass throu=
gh
> > > > > zone_idx=3DMAX_NR_ZONES to become MAX_NR_ZONES-1 in a separate co=
mmit, then
> > > > > remove this interim fixup? I'm worried otherwise we might paper o=
ver real
> > > > > issues in future.
> > > >=20
> > > > Yes, removing this special casing is reasonable. I am not sure
> > > > MAX_NR_ZONES - 1 is a better choice though. It is error prone and
> > > > zone_idx is the highest zone we should consider and MAX_NR_ZONES - 1
> > > > be ZONE_DEVICE if it is configured. But ZONE_DEVICE is really stand=
ing
> > > > outside of MM reclaim code AFAIK. It would be probably better to ha=
ve
> > > > MAX_LRU_ZONE (equal to MOVABLE) and use it instead.
> > >=20
> > > We already use MAX_NR_ZONES - 1 everywhere else in vmscan.c to mean
> > > "no zone restrictions" - get_scan_count() is the odd one out:
> > >=20
> > > - mem_cgroup_shrink_node()
> > > - try_to_free_mem_cgroup_pages()
> > > - balance_pgdat()
> > > - kswapd()
> > > - shrink_all_memory()

There is also=C2=A0inactive_list_is_low(),

if (trace)
	trace_mm_vmscan_inactive_list_is_low(pgdat->node_id, sc->reclaim_idx,
		lruvec_lru_size(lruvec, inactive_lru, MAX_NR_ZONES), inactive,
		lruvec_lru_size(lruvec, active_lru, MAX_NR_ZONES), active,
		inactive_ratio, file);

> > >=20
> > > It's a little odd that it points to ZONE_DEVICE, but it's MUCH less
> > > subtle than handling both inclusive and exclusive range delimiters.
> > >=20
> > > So I think the better fix would be this:
> >=20
> > lruvec_lru_size is explicitly documented to use MAX_NR_ZONES for all
> > LRUs and git grep says there are more instances outside of
> > get_scan_count. So all of them have to be fixed.
>=20
> Which ones?
>=20
> [hannes@computer linux]$ git grep lruvec_lru_size
> include/linux/mmzone.h:extern unsigned long lruvec_lru_size(struct lruvec=
 *lruvec, enum lru_list lru, int zone_idx);
> mm/vmscan.c: * lruvec_lru_size -  Returns the number of pages on the give=
n LRU list.
> mm/vmscan.c:unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru=
_list lru, int zone_idx)
> mm/vmscan.c:    anon  =3D lruvec_lru_size(lruvec, LRU_ACTIVE_ANON, MAX_NR=
_ZONES - 1) +
> mm/vmscan.c:            lruvec_lru_size(lruvec, LRU_INACTIVE_ANON, MAX_NR=
_ZONES - 1);
> mm/vmscan.c:    file  =3D lruvec_lru_size(lruvec, LRU_ACTIVE_FILE, MAX_NR=
_ZONES - 1) +
> mm/vmscan.c:            lruvec_lru_size(lruvec, LRU_INACTIVE_FILE, MAX_NR=
_ZONES - 1);
> mm/vmscan.c:            lruvec_size =3D lruvec_lru_size(lruvec, lru, sc->=
reclaim_idx);
> [hannes@computer linux]$
>=20
> The only other user already passes sc->reclaim_idx, which always
> points to a valid zone, and is initialized to MAX_NR_ZONES - 1 in many
> places.
>=20
> > I still think that MAX_NR_ZONES - 1 is a very error prone and subtle
> > construct IMHO and an alias would be better readable.
>=20
> I wouldn't mind a follow-up patch that changes this pattern
> comprehensively. As it stands, get_scan_count() is the odd one out.
>=20
> The documentation bit is a good point, though. We should fix
> that. Updated patch:
>=20
> ---
>=20
> From b1b6ce306010554aba6ebd7aac0abffc1576d71a Mon Sep 17 00:00:00 2001
> From: Johannes Weiner <hannes@cmpxchg.org>
> Date: Mon, 11 Nov 2019 13:46:25 -0800
> Subject: [PATCH] mm: vmscan: simplify lruvec_lru_size() fix
>=20
> get_scan_count() passes MAX_NR_ZONES for the reclaim index, which is
> beyond the range of valid zone indexes, but used to be handled before
> the patch. Every other callsite in vmscan.c passes MAX_NR_ZONES - 1 to
> express "all zones, please", so do the same here.
>=20
> Reported-by: Qian Cai <cai@lca.pw>
> Reported-by: Chris Down <chris@chrisdown.name>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/vmscan.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index df859b1d583c..5eb96a63ad1e 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -323,7 +323,7 @@ unsigned long zone_reclaimable_pages(struct zone *zon=
e)
>   * lruvec_lru_size -  Returns the number of pages on the given LRU list.
>   * @lruvec: lru vector
>   * @lru: lru to use
> - * @zone_idx: zones to consider (use MAX_NR_ZONES for the whole LRU list)
> + * @zone_idx: index of the highest zone to include (use MAX_NR_ZONES - 1=
 for all)
>   */
>  unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, =
int zone_idx)
>  {
> @@ -2322,10 +2322,10 @@ static void get_scan_count(struct lruvec *lruvec,=
 struct scan_control *sc,
>  	 * anon in [0], file in [1]
>  	 */
> =20
> -	anon  =3D lruvec_lru_size(lruvec, LRU_ACTIVE_ANON, MAX_NR_ZONES) +
> -		lruvec_lru_size(lruvec, LRU_INACTIVE_ANON, MAX_NR_ZONES);
> -	file  =3D lruvec_lru_size(lruvec, LRU_ACTIVE_FILE, MAX_NR_ZONES) +
> -		lruvec_lru_size(lruvec, LRU_INACTIVE_FILE, MAX_NR_ZONES);
> +	anon  =3D lruvec_lru_size(lruvec, LRU_ACTIVE_ANON, MAX_NR_ZONES - 1) +
> +		lruvec_lru_size(lruvec, LRU_INACTIVE_ANON, MAX_NR_ZONES - 1);
> +	file  =3D lruvec_lru_size(lruvec, LRU_ACTIVE_FILE, MAX_NR_ZONES - 1) +
> +		lruvec_lru_size(lruvec, LRU_INACTIVE_FILE, MAX_NR_ZONES - 1);
> =20
>  	spin_lock_irq(&pgdat->lru_lock);
>  	if (unlikely(reclaim_stat->recent_scanned[0] > anon / 4)) {
