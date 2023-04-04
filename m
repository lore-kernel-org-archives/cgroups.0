From: Florian Schmidt <flosch-8cO4VLV/4DJBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC] memcg v1: provide read access to memory.pressure_level
Date: Tue, 4 Apr 2023 09:44:47 +0100
Message-ID: <63942948-a41f-c4c0-dac3-b71adb38496f@nutanix.com>
References: <20230322142525.162469-1-flosch@nutanix.com>
 <20230324150350.fu7itbqqvtjmyf3s@blackpad>
 <6f4420d0-2f86-7294-01e1-6806ef7e4686@nutanix.com>
 <ZCH/RVlh1M6DRXaU@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=CwBd8VIVqig1KSETexcoP8hRMLyRRDRlZpfgmLHt3x4=;
 b=XNhEVMGk+X/Fum0Lijq/qlsAtJjnsWZpIzLlKiAsvKUNJNqkBgQCFOWXeW6ourXDbzyq
 /5jco6EojlE/FPntsEH0aqBZ22VtcOSIQE/38cyUZlBgAX2pK9an44RExlwX4dTKN2hd
 V4FP+1Ps8jjqLRoLtZsvGRdmbZt12PtD0lgjhC8Hr2haSK31fmlUELrMshdHdvNRQENX
 k/ZlpZElSoyCCivnqAal9slBW1IE9i3NPC9j425LsGKqaxS3M53J3T1BIYhHVGL3eL8/
 3+jTX23EXaxiFq5cs/ln1Pi+v74/FLgPwBx4NDPmXOUVcrfeATUdEhvCfsOHePEHvqFa ug== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CwBd8VIVqig1KSETexcoP8hRMLyRRDRlZpfgmLHt3x4=;
 b=oOBqJBgQsai65YnlwhuU4zUOD1/QRBxTrf03XXBlaS3potkcs7t8f2cp/YOrXJZYVyT6k3ztW4L2RxRiOjQSoEvO+Co3ArxtVOXKkI9Pj4zkgPNdvSPaz3t0U/Ev2DVbgaloKVlqrq6hiAiu8uuqN8KZ1FT+A7wDT5k20KkMkQbvmErfR1DWhZE1iDSHp0oQLlHVNlfr6G+sTRq52CHHbsOx7BlJ/T1IiPNKnzwLWWEaUIcyMYFfNGFvqzNCDdF9dz3k7h4L5WOTBxdWOk0S4PKpzdcxeGNPnkN/sZgCVwH/8k1Q1TWhnqg+vhR4+tlnUKCfq2pVpNg8col72i1AWA==
Content-Language: en-US
In-Reply-To: <ZCH/RVlh1M6DRXaU-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi all,

to summarise, I've heard generally positive feedback from Michal H and 
some more reserved, but not fundamentally opposed feedback from Michal 
K. Thanks to both of you.

Since there's been no other feedback for the last few days, I'll raise a 
proper patch, and any potential further discussion can then be done on that.

Cheers,
Florian
