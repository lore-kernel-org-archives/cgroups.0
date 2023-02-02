From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/2] cpuset: Fix cpuset_cpus_allowed() to not filter
 offline CPUs
Date: Thu, 2 Feb 2023 09:34:56 +0100
Message-ID: <Y9t1sP/6nFht7RSN@hirez.programming.kicks-ass.net>
References: <20230131221719.3176-1-will@kernel.org>
 <20230131221719.3176-2-will@kernel.org>
 <6b068916-5e1b-a943-1aad-554964d8b746@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qYRHjdpFC8rwNVpnVUsVW62VMDGH/LfAMOltBaeapz8=; b=hbB48Di5yNViLQvKyzXJLd2eO+
        dY/VBrumUuxNjXWoyQkTykoHyZoNnMSLuTw3cTyDWiloSvSn1AyO8KfJXUeVYyuL/myc88zdKxhbn
        WyRJQnnT/hDfTw1lRxGRbnOLb7RfS8OWzVamBHJ0f2R4kSvCUi087q81qMgHV0f/ibr91K8L3lM33
        QlLcpYH1mYfoWwMWVUjHw4KOZcT+1/ZiazZ1ag6wQVFG2bvzVg8oHWx1U/JQ3Xh0LkjtGMpHlYSwU
        r8MNKzvtULpetEvfvA4w3Dw60F/q5lqAtubxEeGXx2tmGgMUQbIiN7Qtq6XuKe/HR+odRhS5+85+g
        K59hmjBw==;
Content-Disposition: inline
In-Reply-To: <6b068916-5e1b-a943-1aad-554964d8b746-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jan 31, 2023 at 11:14:27PM -0500, Waiman Long wrote:

> A major concern I have is the overhead of creating a poor man version of v2
> cpus_allowed. This issue can be worked around even for cpuset v1 if it is
> mounted with the cpuset_v2_mode option to behave more like v2 in its cpumask
> handling. Alternatively we may be able to provide a config option to make
> this the default for v1 without the special mount option, if necessary.

It is equally broken for v2, it masks against effective_cpus. Not to
mention it explicitly starts with cpu_online_mask.
