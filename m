From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] cgroup, docs: document the root cgroup behavior of
 cpu and io controllers
Date: Tue, 16 Jan 2018 08:08:02 -0800
Message-ID: <20180116160802.GO3460072@devbig577.frc2.facebook.com>
References: <90ac05c0-8e84-0c0b-195a-4c1712e40f09@maciej.szmigiero.name>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QRggEYl9gffKzwvgXjkV2IVzskhuJSrKEdRuBe0WClU=;
        b=onrjfYBJuNU1fasQJQS5u5meHAKuVsVqgXsOf7PG07H8eGV7N67jBivkRCq8iE2h0+
         5VI2GdznM+WxjsbSEzK6qeF2Baumi/LINGCxzBoJ/fUS0dZ2Du+oDwTmB9c+vE5oxyaU
         38R25I6JBVK4UBcgh5HNgf7rS5zZrYYBAisJeQ+4RP+4W0N/R/Eq/djStjDjFAbNptoM
         4yf2/UQMfmgI6V7pTyK1HE1OYz4LhAixkH5tycrtRNlxUBmbiPYew0RVsliTPP3aL86Y
         tJ0EfU5emTDcos3SnaTrIJarp/rOMUPWLiP7aeILbDjlgm39EgK+bXGX4EKu7aBfUGaw
         eGlw==
Content-Disposition: inline
In-Reply-To: <90ac05c0-8e84-0c0b-195a-4c1712e40f09@maciej.szmigiero.name>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>

On Wed, Jan 10, 2018 at 11:33:19PM +0100, Maciej S. Szmigiero wrote:
> Currently, cgroups v2 documentation contains only a generic remark that
> "How resource consumption in the root cgroup is governed is up to each
> controller", which isn't really telling users much, who need to dig in the
> code and / or commit messages to learn the exact behavior.
> 
> In cgroups v1 at least the blkio controller had its operation with respect
> to competition between child threads and child cgroups documented in
> blkio-controller.txt, with references to cfq-iosched.txt.
> Also, cgroups v2 documentation describes v1 behavior of both cpu and
> blkio controllers in an "Issues with v1" section.
> 
> Let's document this behavior also for cgroups v2 to make life easier for
> users.
> 
> Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>

Applied to cgroup/for-4.16.

Thanks.

-- 
tejun
