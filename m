From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 02/14] resource limits: aggregate task highwater marks to
 cgroup level
Date: Mon, 18 Jul 2016 18:52:49 -0400
Message-ID: <20160718225249.GM3078@mtj.duckdns.org>
References: <1468578983-28229-1-git-send-email-toiwoton@gmail.com>
 <1468578983-28229-3-git-send-email-toiwoton@gmail.com>
 <20160715141058.GI3078@mtj.duckdns.org>
 <f6f93ae6-48c4-bce9-08a2-5067919e8748@gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EZs6IQdnQ76eqKkkTkGMR+Pk8iQIVE6N6A5Nx/zF5pI=;
        b=aVmwoWhnDBpala0phq7izCnYwpBl6pvEIBU7dqDfeTV5jlQzAFP7O+7J1CRyZPAJt0
         Y0R1HZb2GQ7y1tQwC5OV0rn0bMtupJghpS/xjRFR+1c42UqQAYibMHgI/mPlqweQk1yJ
         W6KZqJ+e/l/k4lmVfyLQOATuZUwVjcSPdcoYBf5jdeYn3qcOulAZCYXGgyEr28f8zTkR
         l/x8O55l0YfayYga/OlGjqSqIqjtspspdiPEMVlwa/H3/Fwnf/Fe79zvj1aC5E6gi2WW
         lPndQ8EEb4UNm/WV1w6nsZ4fFMZEL3vX8L5j2syoANNBgY1FIIYqPkymTiffEQBF8om6
         r9iw==
Content-Disposition: inline
In-Reply-To: <f6f93ae6-48c4-bce9-08a2-5067919e8748@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Topi Miettinen <toiwoton@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Markus Elfring <elfring@users.sourceforge.net>, "David S. Miller" <davem@davemloft.net>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>

On Fri, Jul 15, 2016 at 05:15:41PM +0000, Topi Miettinen wrote:
> There are clear semantics for the limits themselves, either they apply
> per task or per user. It makes sense to gather values according to these
> semantics. Then with systemd or other tools you can use the valuse to
> set the limits for a service regardless if the limit applies per task or
> per user and it works according to each limit's semantics.

What does it mean to collect the maximum of the high watermarks of
multiple users or the high water marks along process hierarchy which
is spread across multiple cgroups?  These are non-sensical numbers.
If you want to collect high watermarks per-cgroup, the numbers have to
be per-cgroup - how many fds are being used in that particular cgroup
and what's the high watermark of that number and so on.  You can't
just take maximum from process hierarchy or user watermarks.

Thanks.

-- 
tejun
