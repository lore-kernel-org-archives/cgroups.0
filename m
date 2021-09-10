From: "taoyi.ty" <escape@linux.alibaba.com>
Subject: Re: [RFC PATCH 0/2] support cgroup pool in v1
Date: Fri, 10 Sep 2021 10:11:53 +0800
Message-ID: <a0c67d71-8045-d8b6-40c2-39f2603ec7c1@linux.alibaba.com>
References: <cover.1631102579.git.escape@linux.alibaba.com>
 <YTiugxO0cDge47x6@kroah.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <YTiugxO0cDge47x6@kroah.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Greg KH <gregkh@linuxfoundation.org>
Cc: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, mcgrof@kernel.org, keescook@chromium.org, yzaikin@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, shanpeic@linux.alibaba.com

On 2021/9/8 下午8:37, Greg KH wrote:

> Perhaps you shouldn't be creating that many containers all at once?
> What normal workload requires this?

Thank you for your reply.


The scenario is the function computing of the public

cloud. Each instance of function computing will be

allocated about 0.1 core cpu and 100M memory. On

a high-end server, for example, 104 cores and 384G,

it is normal to create hundreds of containers at the

same time if burst of requests comes.

thanks,

Yi Tao

