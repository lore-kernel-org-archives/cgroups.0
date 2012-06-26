From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] fix bad behavior in use_hierarchy file
Date: Tue, 26 Jun 2012 15:30:43 -0700
Message-ID: <20120626223043.GC15811@google.com>
References: <1340725634-9017-1-git-send-email-glommer@parallels.com>
 <1340725634-9017-2-git-send-email-glommer@parallels.com>
 <20120626152522.c7161b5a.akpm@linux-foundation.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=eMkafQ9MeG1S/cgMGQ+AG158Dw2+egmXn//bQUvRQY4=;
        b=oLcu3DdmFg6pHE2eF/tVPZBMlxihaynfg8G1lKHhetemmw3AZ0J2j1BD375lLmVe+j
         0XmzleWJO6JPum+oyxkqhHoH9xRJqdoxkIQUArhErqYPOqdtgIoMTygtIHsvmmgzuQeE
         V9AGQuo9zF3JaZk0Btazw4L0dazhW/Z4hEFOiGRP5VEEK5Jfge0tkcyzoPQtAZw+nOTU
         rb2VffIZxYTyr1mbMkIFtP7D7VMCfAkmrWWL/jYN3/Xj6H9w8N4fE/vzbj0EPXIU9GKA
         9SGnK8YQFigBufqzkaNgUvjGwZX1Owv+vQHRaVZx8yin2fh6TuJkzgwuJhpt6E8GLAFJ
         jmlQ==
Content-Disposition: inline
In-Reply-To: <20120626152522.c7161b5a.akpm@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Glauber Costa <glommer@parallels.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Dhaval Giani <dhaval.giani@gmail.com>, Li Zefan <lizefan@huawei.com>

(cc'ing Li)

Hello, Andrew.

On Tue, Jun 26, 2012 at 03:25:22PM -0700, Andrew Morton wrote:
> hm.  The various .write_u64() implementations go and return zero on
> success and cgroup_write_X64() sees this and rewrites the return value
> to `nbytes'.
> 
> That was a bit naughty of us - it prevents a .write_u64() instance from
> being able to fully implement a partial write.  We can *partially*
> implement a partial write, by returning a value between 1 and nbytes-1,
> but we can't return zero.  It's a weird interface, it's a surprising
> interface and it was quite unnecessary to do it this way.  Someone
> please slap Paul.
> 
> It's hardly a big problem I, but that's why the unix write() interface
> was designed the way it is.

The whole file interface is severely over-designed like a lot of other
things in cgorup.  I'm thinking about consolidating all the different
read/write methods into one generic pair, likely based on seq_file and
make all others helpers.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
