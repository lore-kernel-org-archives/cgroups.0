From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: Make cgroup_rstat_updated() ready for root
 cgroup usage
Date: Thu, 26 Apr 2018 14:36:27 -0700
Message-ID: <20180426213627.GX1911913@devbig577.frc2.facebook.com>
References: <20180323231313.1254142-1-tj@kernel.org>
 <20180402214913.GH388343@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rD9OZQ2cO0CFHiY8VGqEL6WfUuqs2zY9zRhLLcnM/h8=;
        b=YZVEN61D2yx8+M6FQQsK+cgET2ZSxNW8RoWGllPIPu1N201R9smCJ5v4f9FbPDT6RD
         ORm9y/TkhrjzA7LCkV22xkv6y8qIbdWDaDMCaXp3nMm2DXmUS1zTEjUzMbdXI9KPT3dU
         rK+FzBNzua1/XNNFtWQVWUpCK1myKRj6hN89TjWwH+3lJK6BPxOC0QEBv4TDNSv8ZfNw
         DhSxkMnTWArMuk6LT897BFhasjk1h1T9BJZQ16BNdJagKC/xM7w/qyMqTI9R2+btvhKb
         Kua7nUPknS8lXr0kO63QTW7nyXW8rGKb7JULDOMkgaTxiD9QWriKamgwRq6TZCtnFTl3
         2AwQ==
Content-Disposition: inline
In-Reply-To: <20180402214913.GH388343@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, guro@fb.com, kernel-team@fb.com

On Mon, Apr 02, 2018 at 02:49:13PM -0700, Tejun Heo wrote:
> From b7be022bf811d02605098fa61b7545bc146b78e7 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Mon, 2 Apr 2018 14:45:20 -0700
> 
> cgroup_rstat_updated() ensures that the cgroup's rstat is linked to
> the parent.  If there's no parent, it never gets linked and the
> function ends up grabbing and releasing the cgroup_rstat_lock each
> time for no reason which can be expensive.
> 
> This hasn't been a problem till now because nobody was calling the
> function for the root cgroup but rstat is gonna be exposed to
> controllers and use cases, so let's get ready.  Make
> cgroup_rstat_updated() an no-op for the root cgroup.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Applied to cgroup/for-4.18.

Thanks.

-- 
tejun
