From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH -next] mm/vmscan: fix an undefined behavior for zone id
Date: Tue, 12 Nov 2019 13:20:17 -0500
Message-ID: <20191112182017.GB179587@cmpxchg.org>
References: <20191108204407.1435-1-cai@lca.pw>
 <64E60F6F-7582-427B-8DD5-EF97B1656F5A@lca.pw>
 <20191111130516.GA891635@chrisdown.name>
 <20191111131427.GB891635@chrisdown.name>
 <20191111132812.GK1396@dhcp22.suse.cz>
 <20191112145942.GA168812@cmpxchg.org>
 <20191112152750.GA512@dhcp22.suse.cz>
 <20191112161658.GF168812@cmpxchg.org>
 <20191112163156.GB512@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=w8YEl8DjjpzVT+jv1JTvmwB07dFEMqomlwwTe3310pY=;
        b=KGZv5hfKhSeMlIk3qURodC/bAqExsgUF/6lSCR5KsnlI2hk1Vvt1Ez2XgZxpFXA6M5
         8NVnX35tumAMf8vnwXOFXvzbSO92tizrnnR0oG2BuR4cvUtk5ck7y7zDzOFViLG0BLii
         LlqvsQXofXqmA6yYdPv+ou1g+Dj4+W+uI7q/VBfOGf1zGxNnhbdp7/C+cgP1Pchyt/Fa
         nm4DL5uBVj/MkkJRMhVmzu8uNlKaGah+hX5o7Ukk+f2wXdl67Dpk/sfK9/hOPNH1GcT5
         IyMHcklOBzKmgmgdX/rKt3LxiEfgOiElsQ7rJpf5BAx81/PxDpbMsgGNxbZOrH/gntTJ
         PSOQ==
Content-Disposition: inline
In-Reply-To: <20191112163156.GB512@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Chris Down <chris@chrisdown.name>, Qian Cai <cai@lca.pw>, akpm@linux-foundation.org, guro@fb.com, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Nov 12, 2019 at 05:31:56PM +0100, Michal Hocko wrote:
> On Tue 12-11-19 11:16:58, Johannes Weiner wrote:
> > On Tue, Nov 12, 2019 at 04:27:50PM +0100, Michal Hocko wrote:
> > > lruvec_lru_size is explicitly documented to use MAX_NR_ZONES for all
> > > LRUs and git grep says there are more instances outside of
> > > get_scan_count. So all of them have to be fixed.
> > 
> > Which ones?
> > 
> > [hannes@computer linux]$ git grep lruvec_lru_size
> > include/linux/mmzone.h:extern unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone_idx);
> > mm/vmscan.c: * lruvec_lru_size -  Returns the number of pages on the given LRU list.
> > mm/vmscan.c:unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone_idx)
> > mm/vmscan.c:    anon  = lruvec_lru_size(lruvec, LRU_ACTIVE_ANON, MAX_NR_ZONES - 1) +
> > mm/vmscan.c:            lruvec_lru_size(lruvec, LRU_INACTIVE_ANON, MAX_NR_ZONES - 1);
> > mm/vmscan.c:    file  = lruvec_lru_size(lruvec, LRU_ACTIVE_FILE, MAX_NR_ZONES - 1) +
> > mm/vmscan.c:            lruvec_lru_size(lruvec, LRU_INACTIVE_FILE, MAX_NR_ZONES - 1);
> > mm/vmscan.c:            lruvec_size = lruvec_lru_size(lruvec, lru, sc->reclaim_idx);
> > [hannes@computer linux]$
> 
> I have checked the Linus tree but now double checked with the current
> next
> $ git describe next/master
> next-20191112
> $ git grep "lruvec_lru_size.*MAX_NR_ZONES" next/master
> next/master:mm/vmscan.c:                        lruvec_lru_size(lruvec, inactive_lru, MAX_NR_ZONES), inactive,
> next/master:mm/vmscan.c:                        lruvec_lru_size(lruvec, active_lru, MAX_NR_ZONES), active,
> next/master:mm/vmscan.c:        anon  = lruvec_lru_size(lruvec, LRU_ACTIVE_ANON, MAX_NR_ZONES) +
> next/master:mm/vmscan.c:                lruvec_lru_size(lruvec, LRU_INACTIVE_ANON, MAX_NR_ZONES);
> next/master:mm/vmscan.c:        file  = lruvec_lru_size(lruvec, LRU_ACTIVE_FILE, MAX_NR_ZONES) +
> next/master:mm/vmscan.c:                lruvec_lru_size(lruvec, LRU_INACTIVE_FILE, MAX_NR_ZONES);
> next/master:mm/workingset.c:    active_file = lruvec_lru_size(lruvec, LRU_ACTIVE_FILE, MAX_NR_ZONES);
> 
> are there any changes which didn't make it to linux next yet?

Aaahh, that makes sense. I was looking at the latest mmots which
has

- mm: vmscan: detect file thrashing at the reclaim root
- mm: vmscan: enforce inactive:active ratio at the reclaim root

Those replace the inactive_is_low and the workingset callsites with
the recursive lruvec_page_state(). It looks like that isn't in next -
and while I hope it'll make it into 5.5, it might not. So we need a
fix that considers the other callsites as well.

Qian's patches that Andrew already has will be good then, as it
reduces the churn to those other callsites that are in flux.

We can clean things up when the dust settles.
