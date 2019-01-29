From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] mm: Consider subtrees in memory.events
Date: Tue, 29 Jan 2019 06:52:40 -0800
Message-ID: <20190129145240.GX50184@devbig004.ftw2.facebook.com>
References: <20190125182808.GL50184@devbig004.ftw2.facebook.com>
 <20190128125151.GI18811@dhcp22.suse.cz>
 <20190128142816.GM50184@devbig004.ftw2.facebook.com>
 <20190128145210.GM18811@dhcp22.suse.cz>
 <20190128145407.GP50184@devbig004.ftw2.facebook.com>
 <20190128151859.GO18811@dhcp22.suse.cz>
 <20190128154150.GQ50184@devbig004.ftw2.facebook.com>
 <20190128170526.GQ18811@dhcp22.suse.cz>
 <20190128174905.GU50184@devbig004.ftw2.facebook.com>
 <20190129144306.GO18811@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zQdBRqPFHOQNaO1SDGHuI8AHS8ubhF0Kp7ZKbPRa6WM=;
        b=Dz35RfkmFlIAefYXONkJks2DWh4gCYSnDKx7Ic9HCprDFYX5Ou5vbuEIkXMn+z+fVO
         JlHPuKDsGHYaZ5pZSVsoIO7EAEa11SntplExSN4clqxj1CByxBGlYVrJST4PezDYw34n
         Vc/jMONPC/0IrDFDJG3YbY7XtYxPITE6fLy2D7OpGo1S1N/Z/E02SXKASbQoaIFKVk7G
         gBWy0pe9nZYbE5UcQFeAvBwRLg+/EDPeW4VWsHdPRYpsNKmZdE398QzmsTJKW9nGvl+i
         92Mpet2l+ATxjKuy62Xea++iKrZ7k8T3k3Rk3Aj5HsH1IS3R+V/R7YoWg5HgP5Pd274u
         s6Yw==
Content-Disposition: inline
In-Reply-To: <20190129144306.GO18811@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

Hello,

On Tue, Jan 29, 2019 at 03:43:06PM +0100, Michal Hocko wrote:
> All memcg events are represented non-hierarchical AFAICS
> memcg_memory_event() simply accounts at the level when it happens. Or do
> I miss something? Or are you talking about .events files for other
> controllers?

Yeah, cgroup.events and .stat files as some of the local stats would
be useful too, so if we don't flip memory.events we'll end up with sth
like cgroup.events.local, memory.events.tree and memory.stats.local,
which is gonna be hilarious.

If you aren't willing to change your mind, the only option seems to be
introducing a mount option to gate the flip and additions of local
files.  Most likely, userspace will enable the option by default
everywhere, so the end result will be exactly the same but I guess
it'll better address your concern.

Thanks.

-- 
tejun
