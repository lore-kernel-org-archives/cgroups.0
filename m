From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: [PATCH v4 2/2] cgroups: add a pids subsystem
Date: Tue, 10 Mar 2015 07:32:33 -0400
Message-ID: <54FED651.6040100@gmail.com>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>	<1425606357-6337-1-git-send-email-cyphar@cyphar.com>	<1425606357-6337-3-git-send-email-cyphar@cyphar.com>	<20150309033405.GE13283@htj.duckdns.org>	<54FDED43.4050908@gmail.com> <CAOviyah2KCu9K7D_H2zAf3LYbnj65P39YPmNamfA=-SSNq4hOg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:disposition-notification-to:date:from:user-agent
         :mime-version:to:cc:subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        bh=na5wSM/oC2sbPEezYIIkw36vmQb14MKA4uVqmjpFILA=;
        b=ntHASY3rgVq3f97xmutUoXRZFNKyMPGSkYJKnz348w3Ytu09q4/ZdEosuZ13HfnaLL
         yDDYcRGzi+OqpIIcmAN1Ardf+THE+ed7hORliPTfQ+2a85cLJpcZV7rl9K+BQiUaYXuR
         3nwZ4Zc/yqPwUsbjo73mja92619k4irvUzr5BIGCabiPbQTBL2qaOHpSStVOhIlIVtdF
         jl01chdOITJCUstqgTDaomCeoO+1/tPSv+NlTOhurMqzDoAShuV5l/wDdtkBjiuiRZFc
         5sRUN3sL+wQzLhCl7WjFRwHbUTNQpXQ9L2ExlYGUelp5Q8WqJdjYYVMEwenGAhB64k+2
         LxCA==
In-Reply-To: <CAOviyah2KCu9K7D_H2zAf3LYbnj65P39YPmNamfA=-SSNq4hOg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Tejun Heo <tj@kernel.org>, lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org, richard@nod.at, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVj?= =?UTF-8?B?a2Vy?= <fweisbec@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On 2015-03-10 04:10, Aleksa Sarai wrote:
> Hi Austin,
>
>>> Does pids limit make sense in the root cgroup?
>>>
>> I would say it kind of does, although I would just expect it to track
>> /proc/sys/kernel/pid_max (either as a read-only value, or as an alternative
>> way to set it).
>
> Personally, that seems unintuitive. /proc/sys/kernel/pid_max and the pids
> cgroup controller are orthogonal features, why should they be able to affect
> each other (or even be aware of each other)?
I wouldn't consider them entirely orthogonal, the sysctl value is the 
limiting factor for the maximal value that can be set in a given pids 
cgroup.  Setting an unlimited value in the cgroup is functionally 
identical to setting it to be equal to /proc/sys/kernel/pid_max, and the 
root cgroup is functionally equivalent to /proc/sys/kernel/pid_max, 
because all tasks that aren't in another cgroup get put in the root.

My only thought is that having the file that would set the limit there 
might make things much simpler for software that expects the entire 
cgroup structure to be hierarchical.
