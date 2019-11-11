From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH -next] mm/vmscan: fix an undefined behavior for zone id
Date: Mon, 11 Nov 2019 14:28:12 +0100
Message-ID: <20191111132812.GK1396@dhcp22.suse.cz>
References: <20191108204407.1435-1-cai@lca.pw>
 <64E60F6F-7582-427B-8DD5-EF97B1656F5A@lca.pw>
 <20191111130516.GA891635@chrisdown.name>
 <20191111131427.GB891635@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191111131427.GB891635@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: Qian Cai <cai@lca.pw>, akpm@linux-foundation.org, hannes@cmpxchg.org, guro@fb.com, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon 11-11-19 13:14:27, Chris Down wrote:
> Chris Down writes:
> > Ah, I just saw this in my local checkout and thought it was from my
> > changes, until I saw it's also on clean mmots checkout. Thanks for the
> > fixup!
> 
> Also, does this mean we should change callers that may pass through
> zone_idx=MAX_NR_ZONES to become MAX_NR_ZONES-1 in a separate commit, then
> remove this interim fixup? I'm worried otherwise we might paper over real
> issues in future.

Yes, removing this special casing is reasonable. I am not sure
MAX_NR_ZONES - 1 is a better choice though. It is error prone and
zone_idx is the highest zone we should consider and MAX_NR_ZONES - 1
be ZONE_DEVICE if it is configured. But ZONE_DEVICE is really standing
outside of MM reclaim code AFAIK. It would be probably better to have
MAX_LRU_ZONE (equal to MOVABLE) and use it instead.

-- 
Michal Hocko
SUSE Labs
