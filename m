From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH] mm: memcg: Do not count memory.low reclaim if it
 does not happen
Date: Fri, 25 Mar 2022 11:31:18 +0100
Message-ID: <20220325103118.GC2828@blackbody.suse.cz>
References: <20220324095157.GA16685@blackbody.suse.cz>
 <5049EBC3-5BAE-4509-BA63-1F4A7D913517@linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1648204280; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h6jomU3pNhNfJYGm9LatF9aqOCiUlgqkCJJ0ZhBuK44=;
        b=OsMPUua2iforFSm/UO/9WA9UJuZ+xXzZyx7U7SbDGrfPWJ19fd6uUDvHS5HlFiizH8bmb/
        p2dURGMdjGTgK315FM0aQYhh88yWszyYJUdLrvzWW2gJttjV5HsA9O+13YgiZIiNGIXf9t
        fn7HnjdhscuOqORQ1tnVhDPzk3vTItA=
Content-Disposition: inline
In-Reply-To: <5049EBC3-5BAE-4509-BA63-1F4A7D913517-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Richard Palethorpe <rpalethorpe-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>

On Thu, Mar 24, 2022 at 11:17:14AM -0700, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
> Ok, so it’s not really about the implementation details of the reclaim
> mechanism (I mean rounding up to the batch size etc),

Actually, that was what I deemed more serious first.
It's the point 2 of RFCness:

| 2) The observed behavior slightly impacts distribution of parent's memory.low.
|    Constructed example is a passive protected workload in s1 and active in s2
|    (active ~ counteracts the reclaim with allocations). It could strip
|    protection from s1 one by one (one:=SWAP_CLUSTER_MAX/2^sc.priority).
|    That may be considered both wrong (s1 should have been more protected) or
|    correct s2 deserves protection due to its activity.
|    I don't have (didn't collect) data for this, so I think just masking the
|    false events is sufficient (or independent).

> Idk, I don’t have a strong argument against this change (except that
> it changes the existing behavior), but I also don’t see why such
> events are harmful. Do you mind elaborating a bit more?

So I've collected some demo data now.

	systemd-run \
	        -u precious.service --slice=test-protected.slice \
	        -p MemoryLow=50M \
	        /root/memeater 50 # allocates 50M anon, doesn't use it
	
	systemd-run \
	        -u victim.service --slice=test-protected.slice \
	        -p MemoryLow=0M \
	        /root/memeater -m 50 50 # allocates 50M anon, uses it
	
	echo "Started workloads"
	
	systemctl set-property --runtime test.slice MemoryMax=200M
	systemctl set-property --runtime test-protected.slice MemoryLow=50M
	
	sleep 5
	
	systemd-run \
	        -u pressure.service --slice=test.slice \
	        -p MemorySwapMax=0M \ # to push test-protected.slice to swap
	        /root/memeater -m 170 170
	
	sleep 5
	systemd-cgtop -b -1 -m test.slice

Result with memory_recursiveprot

> Control Group                                                        Tasks   %CPU   Memory  Input/s Output/s
> test.slice                                                               3      -   199.9M        -        -
> test.slice/pressure.service                                              1      -   170.5M        -        -
> test.slice/test-protected.slice                                          2      -    29.4M        -        -
> test.slice/test-protected.slice/victim.service                           1      -    29.1M        -        -
> test.slice/test-protected.slice/precious.service                         1      -   292.0K        -        -

Result without memory_recursiveprot

> Control Group                                                        Tasks   %CPU   Memory  Input/s Output/s
> test.slice                                                               3      -   199.8M        -        -
> test.slice/pressure.service                                              1      -   170.5M        -        -
> test.slice/test-protected.slice                                          2      -    29.3M        -        -
> test.slice/test-protected.slice/precious.service                         1      -    28.7M        -        -
> test.slice/test-protected.slice/victim.service                           1      -   560.0K        -        -

(kernel 5.17.0, systemd 249.10)

So with this result, I'd say the event reporting is an independent change
(admiteddly, thanks to the current implementation (not the proposal of
mine) I noticed this issue).
/me scratches head, let me review my other approaches...


Michal
