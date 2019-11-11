From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH -next] mm/vmscan: fix an undefined behavior for zone id
Date: Mon, 11 Nov 2019 11:12:48 +0100
Message-ID: <20191111101248.GF1396@dhcp22.suse.cz>
References: <20191108204407.1435-1-cai@lca.pw>
 <64E60F6F-7582-427B-8DD5-EF97B1656F5A@lca.pw>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <64E60F6F-7582-427B-8DD5-EF97B1656F5A@lca.pw>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qian Cai <cai@lca.pw>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, guro@fb.com, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri 08-11-19 16:26:52, Qian Cai wrote:
> 
> 
> > On Nov 8, 2019, at 3:44 PM, Qian Cai <cai@lca.pw> wrote:
> > 
> > -    for (zid = 0; zid <= zone_idx; zid++) {
> > +    for (zid = 0; zid < zone_idx; zid++) {
> >        struct zone *zone =
> 
> Oops, I think here needs to be,
> 
> for (zid = 0; zid <= zone_idx && zid < MAX_NR_ZONES; zid++) {
> 
> to deal with this MAX_NR_ZONES special case.

Yep this looks correct.

Thanks!

-- 
Michal Hocko
SUSE Labs
