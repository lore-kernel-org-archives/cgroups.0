From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH mmotm/next] cgroup: remove stray references to css_id
Date: Mon, 13 Jan 2014 10:48:54 -0500
Message-ID: <20140113154854.GA29053@htj.dyndns.org>
References: <alpine.LSU.2.11.1401122018400.1701@eggly.anvils>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=LhRnUiDxATw5+q/AoITEkYpB3Uo5F7FWdg3S+ZAcaa8=;
        b=JxdI98FXYOhcMWYkobaUK1+rdDMwQY8Dc/u2JWsMzGFhJMNvntpK5YIqch5AFunMsO
         4qPgQmoeI9EmEcOj1aQYGioOKZXq8jjDpaVT1ze7ACn3SYjMdNphJRjRESdu/yzoQM31
         CTAzKEi+Ct6np7IAAwaoDG91gDJK7koWHUONkLX3p8W/fGhAqV75+KE6ixA1M2PG4ih3
         HnTeoz/9JsCNSImnduo5c8Vf8TwHBqNWq9qEHWjIO/vuaOQzmvibZYUuisGAWd+nfu9g
         aUVvZ72UM8tMXTLK3MSNNEkMZSzZ6/c+D4jIE3GGprpRgNltTmE2LXcoVLsMiTHWA2zd
         SvPw==
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1401122018400.1701@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd@google.com>
Cc: Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, Jan 12, 2014 at 08:23:27PM -0800, Hugh Dickins wrote:
> Trivial: remove the few stray references to css_id, which itself
> was removed in v3.13's 2ff2a7d03bbe "cgroup: kill css_id".
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Applied to cgroup/for-3.14.

Thanks.

-- 
tejun
