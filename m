From: "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] mm: Remove the redundant updating of
 stats_flush_threshold
Date: Fri, 22 Jul 2022 17:57:56 +0000
Message-ID: <DM6PR11MB410736BFD198D38BBCE9E064DC909@DM6PR11MB4107.namprd11.prod.outlook.com>
References: <20220722164949.47760-1-jiebin.sun@intel.com>
 <YtrY5V+dZl4+Gtz4@castle>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658512682; x=1690048682;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xW2SYVOgh4nIyD0QWhReFtVoFFXTUHDlPI8kPQCqskY=;
  b=CjMmDdiHe81cMSlA0BTyST43kDIJOD7OUaq+lRvMc9jxc167AA2a5xPL
   8JNyK+xsDItk9v/pIqoiQcSQuh03PwpZGZ3JL735x9VlrXRJNnlvgNS6B
   /oK/J8e8KRLI0GD998Und+yyDTtKPnNRsQ6dBwSX+yijYXEFOpf24EWml
   6omqJTB/cdb8sgDnjC/T6O6ajt1fkXUOYFkbnwrrDzWwVeZUVa85YI0px
   EBUNNrqvMaeYBmsJK90EXV3jgaIGgSmReP6AoEMbmpUUPZBhVSheZahqH
   fjp0iu3z7NE4gH3EO0yb6jL91jHVAS1wxIcuj/MI142pa6sd97sYnOu8b
   w==;
In-Reply-To: <YtrY5V+dZl4+Gtz4@castle>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "Sun, Jiebin" <jiebin.sun-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "amadeuszx.slawinski-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <amadeuszx.slawinski-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Li, Tianyou" <tianyou.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Guo, Wangyang" <wangyang.guo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

>
>On Sat, Jul 23, 2022 at 12:49:49AM +0800, Jiebin Sun wrote:
>> From: jiebin sun <jiebin.sun-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> Remove the redundant updating of stats_flush_threshold. If the global
>> var stats_flush_threshold has exceeded the trigger value for
>> __mem_cgroup_flush_stats, further increment is unnecessary.
>>
>> Apply the patch and test the pts/hackbench-1.0.0 Count:4 (160 threads).
>>
>> Score gain: 1.95x
>> Reduce CPU cycles in __mod_memcg_lruvec_state (44.88% -> 0.12%)
>>
>> CPU: ICX 8380 x 2 sockets
>> Core number: 40 x 2 physical cores
>> Benchmark: pts/hackbench-1.0.0 Count:4 (160 threads)
>>
>> Signed-off-by: Jiebin Sun <jiebin.sun-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
>Reviewed-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
>
>Good optimization, thanks!

Looks good. Nice performance improvement.

Reviewed-by: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
