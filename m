From: Topi Miettinen <toiwoton@gmail.com>
Subject: Re: [PATCH] capabilities: add capability cgroup controller
Date: Fri, 24 Jun 2016 00:22:54 +0000
Message-ID: <53377cda-9afe-dad4-6bbb-26affd64cb3a@gmail.com>
References: <1466694434-1420-1-git-send-email-toiwoton@gmail.com>
 <20160623213819.GP3262@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=subject:to:references:cc:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=Vl2KKU9ZgibKyNYhGvAF/8VA2/mm1rcgQZniXRJ7U6Q=;
        b=cKDK3w2k4ghsJn/h+rfQRV20iDGPRL0VvSteqM7XLCNHH+yEuVJ+AMU6qSmqSEPOoy
         fXcY2GDftDaR5MBCpA1gZaTyynBTW/DmYBi5N7achfNhzsLZnk72eoQ9m+DTo2PHWGSA
         u4JzqcD1GJMg7P0j4l+ALK+R1CN30BobVDd9KYK0uMFqoMeaK4P1g8cEh+mSM3Mjleh4
         naByuO1eC5nqwgemnzBVJ/LK8Loql+01WqIy9/zSTWTNnC3qmvNg+wDLjFBtCnOJIJs8
         u7H/CL6pPywZA/DAGmufceWAuGVRxkHvV9NQdkdjN4/CMW0JZ1eM54/4XvopOXzvdqRG
         WrYw==
In-Reply-To: <20160623213819.GP3262@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@kernel.org, serge@hallyn.com, keescook@chromium.org, Jonathan Corbet <corbet@lwn.net>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Serge Hallyn <serge.hallyn@canonical.com>, James Morris <james.l.morris@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, David Howells <dhowells@redhat.com>, David Woodhouse <David.Woodhouse@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Petr Mladek <pmladek@suse.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:CAPABILITIES" <linux-security-module@vger.kernel.org>

On 06/23/16 21:38, Tejun Heo wrote:
> Hello,
> 
> On Thu, Jun 23, 2016 at 06:07:10PM +0300, Topi Miettinen wrote:
>> There are many basic ways to control processes, including capabilities,
>> cgroups and resource limits. However, there are far fewer ways to find
>> out useful values for the limits, except blind trial and error.
>>
>> Currently, there is no way to know which capabilities are actually used.
>> Even the source code is only implicit, in-depth knowledge of each
>> capability must be used when analyzing a program to judge which
>> capabilities the program will exercise.
>>
>> Add a new cgroup controller for monitoring of capabilities
>> in the cgroup.
>>
>> Test case demonstrating basic capability monitoring and how the
>> capabilities are combined at next level (boot to rdshell):
> 
> This doesn't have anything to do with resource control and I don't
> think it's a good idea to add arbitrary monitoring mechanisms to
> cgroup just because it's easy to add interface there.  Given that
> capabilities are inherited and modified through the process hierarchy,
> shouldn't this be part of that?

With per process tracking, it's easy to miss if a short-lived process
exercised capabilities. Especially with ambient capabilities, the parent
process could be a shell script which might not use capabilities at all,
but its children do the heavy lifting.

Per process tracking (like in the version I sent earlier) could still be
added on top of this to complement cgroup level tracking, but I think
cgroup approach is more flexible as it can cover anything from a single
task to a collection of processes.

-Topi

> 
> Thanks.
> 

