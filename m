From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 02/14] resource limits: aggregate task highwater marks to
 cgroup level
Date: Fri, 15 Jul 2016 10:10:58 -0400
Message-ID: <20160715141058.GI3078@mtj.duckdns.org>
References: <1468578983-28229-1-git-send-email-toiwoton@gmail.com>
 <1468578983-28229-3-git-send-email-toiwoton@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hCOrRQ+dET8kSpmGhAEUmFuk4rYQqvmZk4/BTZHrqWU=;
        b=vbhPPY60Z374xrTYPYXJhO+iJjf0cbpqblCFN/h+wX9rrF70HMkVGK+Y1zgD8967GC
         PsKicX8XykF3b2adlm8KQKeg2jRR+UJEtysZ/lOH7arbEB2bBHKqn/r810WD3ZlNEANm
         Oz9cbwJ/02xddmKo9pJ3tHK9JzSbuYIsFoxP4HzMSBvy/UqKaEyaglIaMAb0/P2I8ctb
         0TUyv3FghyfJSKdzFby7xXtUJMXuK/YAJ4VACenj6kuTZKNQv/H+aU0nhhUGtBp6JNde
         ttH9EnmFVj797+i4vXNmON80FVPifoOtS2qdClyGxLKcTLzOupdwIqe7AuaYBerP+P2o
         DClw==
Content-Disposition: inline
In-Reply-To: <1468578983-28229-3-git-send-email-toiwoton@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Topi Miettinen <toiwoton@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Markus Elfring <elfring@users.sourceforge.net>, "David S. Miller" <davem@davemloft.net>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>

Hello, Topi.

On Fri, Jul 15, 2016 at 01:35:49PM +0300, Topi Miettinen wrote:
> Collect resource usage highwater marks of a task to cgroup
> statistics when the task exits.

I'm not sure how this makes sense.  The limits are enforced and
collected per user or along the process hierarchy which can be very
different from cgroup organization.  What does collecting high
watermarks from orthogonal structure, sometimes even combining
per-user numbers from different users, even mean?  These are numbers
without clear semantics.

Thanks.

-- 
tejun
