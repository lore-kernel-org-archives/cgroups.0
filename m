From: Topi Miettinen <toiwoton@gmail.com>
Subject: Re: [PATCH 02/14] resource limits: aggregate task highwater marks to
 cgroup level
Date: Fri, 15 Jul 2016 17:15:41 +0000
Message-ID: <f6f93ae6-48c4-bce9-08a2-5067919e8748@gmail.com>
References: <1468578983-28229-1-git-send-email-toiwoton@gmail.com>
 <1468578983-28229-3-git-send-email-toiwoton@gmail.com>
 <20160715141058.GI3078@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=subject:to:references:cc:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=+TUS2Je7SuFMAUOI8TdtRU6VgE00oFWL7VcmzB988W0=;
        b=dsqC1/dNVoYoQ79x1dddR2okesAW6qu73d/saGvSwWP/P3ylqTSnYtT6Cph0nP4v7D
         dOypUJp6W3iZZivJpzfpGktr3U0uWJPAu+HUhuWIhpHCeuM88qxMQEiNZppTBIBEMFIB
         dIchDJ3D1Q7BCVoFPqIHz0eIWg7d6DV62qJl3xJoYJXtbAV79ci0n6G1IuKt7oJmj/1V
         bOO0z9J4i8QoD/N9xWwwx1OouoFbofjGZBrpIIL6RKSt4RoMf47/luVdyPzg5Svq8bBn
         +PXO/HYko6lR3JMCzxO0uXLSPVqK1iDxbqtnMAe+G0ak7TnW7yGf2uoCjFmuk+U/d/zD
         3aLA==
In-Reply-To: <20160715141058.GI3078@mtj.duckdns.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Markus Elfring <elfring@users.sourceforge.net>, "David S. Miller" <davem@davemloft.net>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>

On 07/15/16 14:10, Tejun Heo wrote:
> Hello, Topi.
> 
> On Fri, Jul 15, 2016 at 01:35:49PM +0300, Topi Miettinen wrote:
>> Collect resource usage highwater marks of a task to cgroup
>> statistics when the task exits.
> 
> I'm not sure how this makes sense.  The limits are enforced and
> collected per user or along the process hierarchy which can be very
> different from cgroup organization.  What does collecting high
> watermarks from orthogonal structure, sometimes even combining
> per-user numbers from different users, even mean?  These are numbers
> without clear semantics.

There are clear semantics for the limits themselves, either they apply
per task or per user. It makes sense to gather values according to these
semantics. Then with systemd or other tools you can use the valuse to
set the limits for a service regardless if the limit applies per task or
per user and it works according to each limit's semantics.

cgroups are used to aggregate values from a group of tasks, which still
are related to one service. Because with systemd the services also are
given a cgroup context, the values will completely make sense there too.

It could be useful to introduce a new set of limits that apply only
cgroup level. It would not remove the need to aggregate values from a
group of tasks.

-Topi

> 
> Thanks.
> 

