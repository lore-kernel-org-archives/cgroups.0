From: Tim Murray <timmurray@google.com>
Subject: Re: [RFC 0/1] add support for reclaiming priorities per mem cgroup
Date: Thu, 30 Mar 2017 14:54:28 -0700
Message-ID: <CAEe=Sxmj6wHN9HzAix9F4HDhk9ojYaMrStE1b1MxB0VvMzd=Ug@mail.gmail.com>
References: <20170317231636.142311-1-timmurray@google.com> <20170330155123.GA3929@cmpxchg.org>
 <CAEe=SxmpXD=f9N_i+xe6gFUKKUefJYvBd8dSwxSM+7rbBBTniw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=r3Yj4HRF2OSIooVWy78Z4jt9YmZTFQ2lyumYJKPj8Dw=;
        b=v7w5QhdN8Z6qFo1eBMEJ8O+lMajtb+WKPkkbh/4cSunFvk/7+S7PLAsjF43kb7iitB
         +x8l9SsL08vv/jwiRfc6SBlKpDBwDnHHqKD9o+A+XC0wowl2xM7H+JVhh8dKN0Cpq7rv
         jBn4y+zmEmFfl8+9Pa20uOeJ6K24IbqMO1heiYJ2+BD/uow8AySBRuEFLeFx1PF6uWBS
         mId/iIIRC9XVw9T0GplOigqD90hm+AUbbjeI4U9/PbTu/CxBoPNQttECzG1qStivQIt6
         ms3lIluSUZfSpRVDUVf80rWnHRJq5G1/PRVVtap3Z4a7ndt2M/NkjQAwQtZt2O+trVKv
         4vRA==
In-Reply-To: <CAEe=SxmpXD=f9N_i+xe6gFUKKUefJYvBd8dSwxSM+7rbBBTniw@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, LKML <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, Linux-MM <linux-mm@kvack.org>, Suren Baghdasaryan <surenb@google.com>, Patrik Torstensson <totte@google.com>, Android Kernel Team <kernel-team@android.com>

On Thu, Mar 30, 2017 at 12:40 PM, Tim Murray <timmurray@google.com> wrote:
> The current critical vmpressure event
> hasn't been that successful in avoiding oom-killer (on 3.18, at
> least)--I've been able to get oom-killer to trigger without a
> vmpressure event.

Looked at this some more, and this is almost certainly because
vmpressure relies on workqueues. Scheduling delay from CFS workqueues
would explain vmpressure latency that results in oom-killer running
long before the critical vmpressure notification is received in
userspace, even if userspace is running as FIFO. We regularly see
10ms+ latency on workqueues, even when an Android device isn't heavily
loaded.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
