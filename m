From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH v2 11/17] cgroup: Implement new thread mode semantics
Date: Fri, 19 May 2017 16:58:20 -0400
Message-ID: <20170519205820.GE15279@wtj.duckdns.org>
References: <1494855256-12558-1-git-send-email-longman@redhat.com>
 <1494855256-12558-12-git-send-email-longman@redhat.com>
 <20170519202624.GA15279@wtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ja+YNNpZwZ4MAgQ5Jbqlc808GB39ezYXiIqWQoaVfTg=;
        b=AQv2T4/6cuucINiK9pCfDMknJxpIz5vH34E0RSX6cnD82Znjg+U0nakXaToZojjnfB
         AbObnt2XIBg6lfn3kwsIw/HDw76ZKIk0wcMlhiwxm9IQMdxvdjP2VfZfIP5ULHlw4rzr
         78F3s3FqIIdHaWxHkOoXP4X8vaRajB31gcIxlYey3q6PjpTo5LVKRGXOUW/sphrl1rAD
         GKvkHoo2zCyFzW7ODWtCrQ/7vhOb0Mz5mH6aO2T5xL7yS6QNO6ZW9bwotgekCBMwsSR1
         GFXkpJOLvyxjKnLp4wVkmn4hCVvCkpc+QDt7vgvalUCoE8edrM/RT2zfsvyLyaqH+sV/
         gtWA==
Content-Disposition: inline
In-Reply-To: <20170519202624.GA15279@wtj.duckdns.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de

Hello,

On Fri, May 19, 2017 at 04:26:24PM -0400, Tejun Heo wrote:
> (exactly in the way necessary), I wonder whether it'd be better to
> simply allow root to be both domain and thread root.

I'll give this approach a shot early next week.

Thanks.

-- 
tejun
