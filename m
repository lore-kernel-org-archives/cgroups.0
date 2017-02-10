From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET for-4.11] cgroup: implement cgroup v2 thread mode
Date: Fri, 10 Feb 2017 10:46:14 -0500
Message-ID: <20170210154614.GB16097@mtj.duckdns.org>
References: <20170202200632.13992-1-tj@kernel.org>
 <CAPM31RKHsM1-iWb5B6jkOtLomLhiOARtgMOTWZ8p1yjEn-ZK0A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EjzILj/vvuU8OFK2WQQ8S6rVzXNrrt3WhnaEyBniVHI=;
        b=UIJXPhHIoxUvtLDI01Gn8AdO7wG5h9YdP5hKbOTL5/LpFBhWBFo8MN8Li95qa/mVTf
         4nNcg22EV7CvJ1tSgOB1n2V6sRnzFjSNSjHI4OkgPioRAXx2Py0fnDi5OXNHs9Mk1B8f
         +M/bpEhu2BPYv8+NZM8h3oFQp7l9Qna2+DCNqYu2ChAsJzbjCS99GM7UazUm8eBFrEhl
         YjpkRCqUFvutlpdTGAJtLetU2Q2+00/9ZXDxV5VhNyD8IvdryHh5ahK2+GeCp3PXHuuz
         VHFRkkPpIMbG0xmG/Jtj8H7sjzeOqH5FkazwoJ0Kj0whSP6IK+8EmVTjpetnHmPoD2In
         o9Yw==
Content-Disposition: inline
In-Reply-To: <CAPM31RKHsM1-iWb5B6jkOtLomLhiOARtgMOTWZ8p1yjEn-ZK0A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Mike Galbraith <efault-Mmb7MZpHnFY@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, lvenanci-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Thu, Feb 09, 2017 at 05:07:16AM -0800, Paul Turner wrote:
> What are the motivations that you see for forcing this all onto one
> mount-point via .threads sub-tree tags?

So, you wanted rgroup but with /proc interface?  I'm afraid it's too
late for that.

Thanks.

-- 
tejun
