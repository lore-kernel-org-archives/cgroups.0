From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/2] cgroup v2 freezer follow-up patches
Date: Mon, 6 May 2019 08:40:23 -0700
Message-ID: <20190506154023.GP374014@devbig004.ftw2.facebook.com>
References: <20190426175945.2559865-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Z/JZRQAUubCvOOmwPXa9vzQ22nhQDYk8gbHs+6tTepg=;
        b=u7pVVXVWWeyXope1cvFsPdbqh1azIgGjmAJyXSzAwwrh4VZcnx4EH5gFy3+S4dIgPw
         rvuk1XWasLvn2RAB1cqGA4n4Pn42rLDS/nTz7oB0VY4R0UzuEifmx6bcHid1eRcLOZcc
         gxTjnES/yBuyVtEdt+fZ2h3ZA42RXU3pCgPCn8YvfKht6KVCa0Cn1DnH/pqjdE6l/x/R
         80Vq5+BTRc/X/rQl3vKMlTF+e1uyTDJYSg4XRRtCP7YpD3rtOYD9xrVu8MLTsi5RNUM8
         Lfr+nVaGmea1gc9njhmP1lbBoeWBeEiKyRoq3N19cQb6leF8p5l3FjTK93TkggBgbceq
         Brdg==
Content-Disposition: inline
In-Reply-To: <20190426175945.2559865-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Oleg Nesterov <oleg@redhat.com>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Apr 26, 2019 at 10:59:43AM -0700, Roman Gushchin wrote:
> Hi, Tejun!
> 
> Please, pull these two follow-up patches for the cgroup v2 freezer.
> 
> These are a fix for a spurious state transition, which could happen
> due to a race condition, and a cleanup of some dead code. Both patches
> were suggested by Oleg Nesterov.

Applied to cgroup/for-5.2.

Thanks.

-- 
tejun
