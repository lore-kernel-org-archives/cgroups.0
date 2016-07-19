From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 02/14] resource limits: aggregate task highwater marks to
 cgroup level
Date: Tue, 19 Jul 2016 14:18:15 -0400
Message-ID: <20160719181815.GI3078@mtj.duckdns.org>
References: <1468578983-28229-1-git-send-email-toiwoton@gmail.com>
 <1468578983-28229-3-git-send-email-toiwoton@gmail.com>
 <20160715141058.GI3078@mtj.duckdns.org>
 <f6f93ae6-48c4-bce9-08a2-5067919e8748@gmail.com>
 <20160718225249.GM3078@mtj.duckdns.org>
 <08d85be0-5ac7-d7ea-0fec-ceb3970f264b@gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2/6Z3w+cdy2Ed85d0Pb6iCjsfIIsQ6z1NhS8uHoQv/s=;
        b=BwzGFxqJ7T6oe3YvMcGDdvxyQlWX6H0XfoZcBblDAujTYit4uP7WOY7taAHsxt4g8r
         sSgVC9i/e+bZyGkXpwKO6tl8had68LADo6IMrVr47sxPCRiggSABPzTV5iAlLNDDA637
         9qF+TtsJnzZZ4KX5uoTkBMw9udp3jL2DzX3FBHWJMdbKGV7Jp1hB4/erlapYmis3J1J4
         ibtVlrrFw7kzyk65sn1RrUu2DMFxBf39uuOxwy5mvxlPQgby29fXHQKn3TRfH1NR+deO
         E+n6wBrOEwpoqLZ46uCsX0jRI8hNnGw2tb1rBnhImnvWgAU+m2oDNkTvD9sOFbBRByF3
         nlsg==
Content-Disposition: inline
In-Reply-To: <08d85be0-5ac7-d7ea-0fec-ceb3970f264b@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Topi Miettinen <toiwoton@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Markus Elfring <elfring@users.sourceforge.net>, "David S. Miller" <davem@davemloft.net>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>

Hello, Topi.

On Tue, Jul 19, 2016 at 04:57:10PM +0000, Topi Miettinen wrote:
> Then there would need to be new limit checks at cgroup level. Would you
> see problems with that approach?

I'm worried that you're rushing this feature without thinking through
it.  You were mixing up completely orthogonal planes of accounting and
control without too much thought and are now suggesting something
which is also strange.  What do you mean by "new limit checks at
cgroup level"?  How would this be different from the resource
accounting and control implemented in the existing controllers?

Please take a step back and think through the overall design before
proposing changes to userland visible interface.

Thanks.

-- 
tejun
