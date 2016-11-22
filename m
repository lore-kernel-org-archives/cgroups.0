From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: memory.force_empty is deprecated
Date: Tue, 22 Nov 2016 16:20:37 +0100
Message-ID: <20161122152037.GA6844@dhcp22.suse.cz>
References: <OF57AEC2D2.FA566D70-ON48258061.002C144F-48258061.002E2E50@notes.na.collabserv.com>
 <20161104152103.GC8825@cmpxchg.org>
 <OF1D622B5E.2C033199-ON4825806E.0032B4F0-4825806E.00382767@notes.na.collabserv.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <OF1D622B5E.2C033199-ON4825806E.0032B4F0-4825806E.00382767-8eTO7WVQ4XIsd+ienQ86orlN3bxYEBpz@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhao Hui Ding <dingzhh-vtt25B2cwJLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Xue Bin Min <minxb-vtt25B2cwJLQT0dZR+AlfA@public.gmane.org>

On Thu 17-11-16 18:13:18, Zhao Hui Ding wrote:
[...]
> We cannot leave it lazily because when new job reuse the cgroup, "cache" 
> doesn't be cleaned automatically.
> We need a mechanism that clean memory.stat.

Could you clarify why, please?
-- 
Michal Hocko
SUSE Labs
