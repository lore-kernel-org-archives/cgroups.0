From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH RFC] cpuset: Make cpusets get restored on hotplug
Date: Thu, 26 Mar 2020 23:32:25 -0400
Message-ID: <20200327033225.GA250520@google.com>
References: <20200326191623.129285-1-joel@joelfernandes.org>
 <20200326192035.GO162390@mtj.duckdns.org>
 <20200326194448.GA133524@google.com>
 <972a5c1b-6721-ac20-cec5-617af67e617d@redhat.com>
 <CAPz6YkVUsDz456z8-X2G_EDd-uet1rRNnh2sDUpdcoWp_fkDDw@mail.gmail.com>
 <20200326201649.GQ162390@mtj.duckdns.org>
 <20200326202340.GA146657@google.com>
 <592d4120-0b42-4607-5efd-fb2d4d29f0cc@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=r71azbnhZkfrbX5EBuBZs+Z142rnXfAai7VBmmvucRQ=;
        b=k/l+7EzRvmXCev0yuQZ0c5mJXHjOLfvHQv5AbXX/oUQO+o9lT3gePYJcarWNlmcpCv
         ClHFnZTbq4sfmSoo8TOlCB6tzUEW7P/5gEYXFW/YRX3Pkssb9HoAXHR4MzQS6h3cMcRV
         nsx+2eXk4NImybe1UdIJbSYaSvypRWxcmZktI=
Content-Disposition: inline
In-Reply-To: <592d4120-0b42-4607-5efd-fb2d4d29f0cc@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Sonny Rao <sonnyrao@google.com>, linux-kernel@vger.kernel.org, Dmitry Shmidt <dimitrysh@google.com>, Amit Pundir <amit.pundir@linaro.org>, kernel-team@android.com, Jesse Barnes <jsbarnes@google.com>, vpillai@digitalocean.com, Peter Zijlstra <peterz@infradead.org>, Guenter Roeck <groeck@chromium.org>, Greg Kerr <kerrnel@google.com>, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>

On Thu, Mar 26, 2020 at 09:26:51PM -0400, Waiman Long wrote:
[...]
> I think the problem is that the v2_mode mount option is not that well
> documented. Maybe I should send a patch to add some some description
> about it in cgroup-v2.rst or cgroup-v1/cpusets.rst.

That is definitely worth it and I would fully support that.

thanks,

 - Joel

