From: Topi Miettinen <toiwoton@gmail.com>
Subject: Re: [PATCH 02/14] resource limits: aggregate task highwater marks to
 cgroup level
Date: Tue, 19 Jul 2016 16:57:10 +0000
Message-ID: <08d85be0-5ac7-d7ea-0fec-ceb3970f264b@gmail.com>
References: <1468578983-28229-1-git-send-email-toiwoton@gmail.com>
 <1468578983-28229-3-git-send-email-toiwoton@gmail.com>
 <20160715141058.GI3078@mtj.duckdns.org>
 <f6f93ae6-48c4-bce9-08a2-5067919e8748@gmail.com>
 <20160718225249.GM3078@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=subject:to:references:cc:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=0YI90Sc4V696cETuzTKypgLVyqNWFj+si72IlDmuxN4=;
        b=VaKrAlCfqYyIuWrYZrDJB3zMtnmqLBMfr2t2cRktrDT/FDfwuzlWaFfizohpyRmZzE
         E01xRMLTd+Y+/aoIu4DHgIBJfLE7Yh+3oA1l95lNHBEAJLkVxTi8oU5oGVhbg8Vt/ti5
         aydTEFfON+6QZ3G0dj62nDUuMUVpa4DLRfTYEgvY7Nf+bStRIi5aLtMCeyYhB/VCfUhu
         cbp7+8AYxeo3x1dn30mnnE8L7xZK8X4yGyAGhr3AaGJN3c++8yX1ztZL+7X2WyR2+frL
         vuSOtWLmdnEic/BwKHXAjvYdSOCS923betj8VwB4tNJm0VLfEKAnQ3Kh1evL5VQ1XCpa
         12nQ==
In-Reply-To: <20160718225249.GM3078@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Markus Elfring <elfring@users.sourceforge.net>, "David S. Miller" <davem@davemloft.net>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>

On 07/18/16 22:52, Tejun Heo wrote:
> On Fri, Jul 15, 2016 at 05:15:41PM +0000, Topi Miettinen wrote:
>> There are clear semantics for the limits themselves, either they apply
>> per task or per user. It makes sense to gather values according to these
>> semantics. Then with systemd or other tools you can use the valuse to
>> set the limits for a service regardless if the limit applies per task or
>> per user and it works according to each limit's semantics.
> 
> What does it mean to collect the maximum of the high watermarks of
> multiple users or the high water marks along process hierarchy which
> is spread across multiple cgroups?  These are non-sensical numbers.
> If you want to collect high watermarks per-cgroup, the numbers have to
> be per-cgroup - how many fds are being used in that particular cgroup
> and what's the high watermark of that number and so on.  You can't
> just take maximum from process hierarchy or user watermarks.

Then there would need to be new limit checks at cgroup level. Would you
see problems with that approach?

-Topi

