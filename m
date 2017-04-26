From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 00/14] cgroup: Implement cgroup v2 thread mode & CPU
 controller
Date: Wed, 26 Apr 2017 15:30:47 -0700
Message-ID: <20170426223047.GA11348@wtj.duckdns.org>
References: <1492783452-12267-1-git-send-email-longman@redhat.com>
 <fa35c889-85a8-8b85-c836-4c5070cd7cdc@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FLua3pUO7slupgbiK0gOKBwTST6srxYYQ61188pZiDI=;
        b=go3MTzRFW3VD43SXmT7ob3BcasjAJcn9iqBK00OoZwuj3E/oJvhxg75XyAMQXV26TI
         D5k8DhUCrGYjT0fzMvtkyWMtdGU9kZoSBpLlEvDuEMiGliz/F5Q4r3VD7ToohGzEnryc
         MpFgzdZX8d95Lcmofi4wRF9yGXW06aVnz9ggA4WtKM7+NEGhZxWIac8sgUH8Jm/B9kRS
         7jW/U6lmIegN8UiUZwiGFWKj0TYt3sPxuh4oaSTsHDniOHzqmbVgLOWCpxyVl6/QrfMF
         5S4qJQE3Np21InQ5h/0hbfF8wx8TCbvm5qVa6Thga3JTL5lLcOa+m4XJ3vLuT4OcUa7L
         lYgw==
Content-Disposition: inline
In-Reply-To: <fa35c889-85a8-8b85-c836-4c5070cd7cdc@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de

Hello, Waiman.

On Wed, Apr 26, 2017 at 12:05:27PM -0400, Waiman Long wrote:
> Does anyone has time to take a look at these patches?
> 
> As the merge window is going to open up next week, I am not going to
> bother you guys when the merge window opens.

Will get to it next week.  Sorry about the delay.  We're deploying
cgroup2 across the fleet and seeing a lot of interesting issues and I
was chasing down CPU controller performance issues for the last month
or so, which is now getting wrapped up.

Thanks.

-- 
tejun
