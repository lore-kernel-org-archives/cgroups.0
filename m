From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH V2] cgroup: Introduce cgroup_detach_task().
Date: Mon, 25 Aug 2014 10:47:10 -0400
Message-ID: <20140825144710.GA21688@htj.dyndns.org>
References: <1408966330-2374-1-git-send-email-yangds.fnst@cn.fujitsu.com>
 <20140825141220.GA31066@mtj.dyndns.org>
 <CA+qeAOq7hYq-TJMh8jQpJy=nWwk2FsUMSS1Hd=-JkhLLXbweEQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=4MCSxbX+khC9sEMttFX7O9BCm5f0lhjpY5YmACNuijU=;
        b=IQ1gd+bLc9sH8anbmyvRBjaOIiSqCcfxWd0ofaam+4UbXYf9FMIxTOXzpynm5u/Nre
         SGdXqz7TrEZxkwoZC9sl0C3WyTRCehZG7k2l+wqEEqOZPJ3RMgH5mZiilGmPOMUZeayu
         PNG8Ehy+0MyTb1EASdkPRPufAe27N6LrdoipeldlZW0PjOzfG+qp+y0uae+Dm3c4mwjC
         T6SOQzHx+vG/a6TunHz4ElZMuii9fBzwCqwwJnebF7XXzKUzBKKLlbBB7paFEuHJV3qi
         5l+8fd13eFRX3/E3KP1pVFiqt2wDVWw8TPAztBJ7jo+Lh2uA8pPoGvb6rP/NMblsxBY0
         UeOw==
Content-Disposition: inline
In-Reply-To: <CA+qeAOq7hYq-TJMh8jQpJy=nWwk2FsUMSS1Hd=-JkhLLXbweEQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dongsheng Yang <dongsheng081251@gmail.com>
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 10:46:03PM +0800, Dongsheng Yang wrote:
> My point here is that attaching and detaching are a pair of operations.

There is no detaching from a cgroup.  A task is always attached to a
cgroup whether that's a root or non-root cgroup.

Thanks.

-- 
tejun
