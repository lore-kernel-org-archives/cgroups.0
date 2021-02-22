From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 3/3] mm: Fix missing mem cgroup soft limit tree updates
Date: Mon, 22 Feb 2021 09:45:12 -0800
Message-ID: <fdc2a811-0a05-b706-a6f5-b686507caf56@linux.intel.com>
References: <cover.1613584277.git.tim.c.chen@linux.intel.com>
 <e269f5df3af1157232b01a9b0dae3edf4880d786.1613584277.git.tim.c.chen@linux.intel.com>
 <YC+B2KvJVSgfVDTe@dhcp22.suse.cz>
 <1ecd277e-c236-08e1-f068-3dd65ee0e640@linux.intel.com>
 <YDNuRFgJPH4bPEbq@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YDNuRFgJPH4bPEbq-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2/22/21 12:41 AM, Michal Hocko wrote:

>>
>>
>> Ah, that's true.  The added check for soft_limit_excess is not needed.
>>
>> Do you think it is still a good idea to add patch 3 to
>> restrict the uncharge update in page batch of the same node and cgroup?
> 
> I would rather drop it. The less the soft limit reclaim code is spread
> around the better.
> 

Let's drop patch 3 then.  I find patch 2 is the most critical one in this series.  
Without that patch some cgroups exceeds the soft limit excess very badly.

Tim
