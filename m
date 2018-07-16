From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v13 0/7] cgroup-aware OOM killer
Date: Mon, 16 Jul 2018 15:09:21 -0700
Message-ID: <20180716220918.GA3898@castle.DHCP.thefacebook.com>
References: <20171130152824.1591-1-guro@fb.com>
 <20180605114729.GB19202@dhcp22.suse.cz>
 <alpine.DEB.2.21.1807131438380.194789@chino.kir.corp.google.com>
 <0a86d2a7-b78e-7e69-f628-aa2c75d91ff0@i-love.sakura.ne.jp>
 <0d018c7e-a3de-a23a-3996-bed8b28b1e4a@i-love.sakura.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=UtwC/tk2CmIwywKkFSnhK9NMVhM9ctrpgWHZMq2l6Bs=;
 b=fc60SGi8JfcvTZz/PCi9DYxHZ09jQl3VKqeJkMI4DtRNT9ckTIMjctMkl3zGa6RCEt4N
 B2MVgpYBFEuxKAKWa/egfrcm4DcJ7Y1c/GLoMHEQJZDKKBeXpGZcZ6qBooTBYEc6VVTa
 2x7jm+7ML3R5csZ3SU/n4BTZEhThnm0svYo= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UtwC/tk2CmIwywKkFSnhK9NMVhM9ctrpgWHZMq2l6Bs=;
 b=PxdrHb43VYXefhy+O0TUtGA3uy/vXF8QIOKWTGMszfVm1woCKoO1kBvtZrN5YCFN9zRV/R7OUwuIT/IqMfHymw8vk2S3Ja61m2FDh/rf8HePZvXsTe/gJb18E3YhDQvJUZA/dG4wQgpUMsxVFJ1aHQjl390Fa2VuEQjKySd1zpc=
Content-Disposition: inline
In-Reply-To: <0d018c7e-a3de-a23a-3996-bed8b28b1e4a@i-love.sakura.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@kernel.org>, linux-mm@vger.kernel.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Tue, Jul 17, 2018 at 06:13:47AM +0900, Tetsuo Handa wrote:
> No response from Roman and David...
> 
> Andrew, will you once drop Roman's cgroup-aware OOM killer and David's patches?
> Roman's series has a bug which I mentioned and which can be avoided by my patch.
> David's patch is using MMF_UNSTABLE incorrectly such that it might start selecting
> next OOM victim without trying to reclaim any memory.
> 
> Since they are not responding to my mail, I suggest once dropping from linux-next.

I was in cc, and didn't thought that you're expecting something from me.

I don't get, why it's necessary to drop the cgroup oom killer to merge your fix?
I'm happy to help with rebasing and everything else.

Thanks,
Roman
