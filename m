From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3] cpuset: Enable cpuset controller in default hierarchy
Date: Thu, 26 Oct 2017 07:39:08 -0700
Message-ID: <20171026143908.GD59538@devbig577.frc2.facebook.com>
References: <1507324230-22996-1-git-send-email-longman@redhat.com>
 <db119820-84d4-7ccb-e65a-966d2d7aaf02@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qKHHBnXTIV+8LioEnekIyQrYZ2xKbbNj2Lvc+LzwUkY=;
        b=SJy84wBoeKCACdxjx+HhzIdL/tV1huhwnOzlAl/kEn+Z6KobV7qfctXBYislpenala
         DQuUgs3YLRaqxp9ectWj8gY9GGapf0sNCqDiGCnlXkfqhIBzUub5aB14OGyuUakYLKph
         lLTBAd/LCWIZ6XUcrYt5CPrKUxzYO6VewP5Dh1xkMUUlI8bn8DMogWfjiosGsAI2nNHU
         nnMckNqHPZdtxk6ffgjNBQvD7MVwitozu7dN7SqgI9VudRneoDCW1GzfoT4iz0/vNOQh
         lkXZ1KPk3jpRt7yYc42pwmwLCqsXWW0MEVFlpIc/2EwBn20XUM9k9VRnbt2dhouMOgUC
         1Cxg==
Content-Disposition: inline
In-Reply-To: <db119820-84d4-7ccb-e65a-966d2d7aaf02@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Mike Galbraith <efault@gmx.de>, Christian Brauner <christian.brauner@canonical.com>, =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>, Serge Hallyn <serge@hallyn.com>

Hello, Waiman.

On Wed, Oct 25, 2017 at 11:50:34AM -0400, Waiman Long wrote:
> Ping! Any comment on this patch?

Sorry about the lack of response.  Here are my two thoughts.

1. I'm not really sure about the memory part.  Mostly because of the
   way it's configured and enforced is completely out of step with how
   mm behaves in general.  I'd like to get more input from mm folks on
   this.

2. I want to think more about how we expose the effective settings.
   Not that anything is wrong with what cpuset does, but more that I
   wanna ensure that it's something we can follow in other cases where
   we have similar hierarchical property propagation.

We're likely too late for the coming merge window.  Let's handle it
during the next window.

Thanks and my apologies for the delay.

-- 
tejun
