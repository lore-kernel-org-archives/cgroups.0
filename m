From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 0/2] cgroup: allow management of subtrees by new
 cgroup namespaces
Date: Fri, 20 May 2016 09:17:59 -0700
Message-ID: <20160520161759.GD5632@htj.duckdns.org>
References: <1463196000-13900-1-git-send-email-asarai@suse.de>
 <573F23D0.2030500@suse.de>
 <20160520152244.GB5632@htj.duckdns.org>
 <1463758258.8091.3.camel@HansenPartnership.com>
 <20160520160352.GC5632@htj.duckdns.org>
 <1463760550.8091.13.camel@HansenPartnership.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hOOyc1RhBYHh/8vFLnY6Q0JM4XOw4OeJA0aN1xoHQMI=;
        b=ZDo4I6+HoKrVWg3VPjBXLPOMB5pDCJFNfrKoRfDRkYL+ursJzLZIN8DJy6py93XuhI
         5gxP3IZWy7r8fLl58QtHaB7l7W+RAlodBhRlBXVVSwy91Nc4Q69e1VzGc6VQrRIM9eKi
         cburqiw0CHlyiJqWXETPffD6D4Fo8Kep8f8rk0gi6VIB2F9VsGzA8dmq7T5Tg/rmVnVQ
         IUYXFC6rOhXNlCzb76gcVEE1L584xKBVYNYaWrlz7dnVO5Nr6Ior4fIgrevQ5LY5nz4Y
         1RU9clAY1bjuMFoilFM0+F5G28rVrK+pzILMwDjlTmmShxmUiPzKcQs/KdvyNzTWlQKe
         s97w==
Content-Disposition: inline
In-Reply-To: <1463760550.8091.13.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Aleksa Sarai <asarai@suse.de>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Aleksa Sarai <cyphar@cyphar.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, dev@opencontainers.org

Hello, James.

On Fri, May 20, 2016 at 12:09:10PM -0400, James Bottomley wrote:
> I think it's just different definitions.  If you take on our definition
> of being able to set up a container without any admin intervention, do
> you see our problem: we can't get the initial delegation of the
> hierarchy.

Yeah, I can see the difference but we can't solve that by special
casing NS case.  This is stemming from the fact that an unpriv
application can't create its sub-cgroups without explicit delegation
from the root and that has always been an explicit design choice.
It's tied to who's responsible for cleanup afterwards and what happens
when the process gets migrated to a different cgroup.  The latter is
an important issue on v1 hierarchies because migrating tasks sometimes
is used as a way to control resource distribution.

Thanks.

-- 
tejun
