From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v10 0/9] freezer for cgroup v2
Date: Fri, 19 Apr 2019 11:29:45 -0700
Message-ID: <20190419182945.GH374014@devbig004.ftw2.facebook.com>
References: <20190405174708.1010-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EGfjoyWDUmP1Izi9Q+pi/Uu5LN32TT8JKGIaCUuqYyg=;
        b=rQjb7ofOHQ/DGV9bGEujyiPdbToUujv3TKhbcFidNAeU8X1gNU+R2aFUsoDd6Ay72b
         fzN4RAxkQAo0kMYnP79v4fkq3ic7zjcwQbJGwYVJVc+ExBUGXcjK4pQTA5FRgWxLlJX+
         QnqSuqQKewniKKCg1+yi9Ufrx31MrjEl80ftj9ZzaZcCfOHIHXhVKz/MxWGMn0FUxTq6
         DSbNBbxdCRmanQLAw1eeCs77LMa/Y0yvmCI71NMvcLiaqeSwFKAL0BMiuj/TQArO0UDo
         xPdKtyrmfR5V3GuFJ1w4j1QUNRIuUJTAwbhilYkBKol3U77H1p0Yv9euO2UuGpAceV3Q
         vmbw==
Content-Disposition: inline
In-Reply-To: <20190405174708.1010-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guroan@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>

On Fri, Apr 05, 2019 at 10:46:59AM -0700, Roman Gushchin wrote:
> This patchset implements freezer for cgroup v2.
> 
> It provides similar functionality as v1 freezer, but the interface
> conforms to the cgroup v2 interface design principles, and it
> provides a better user experience: tasks can be killed, ptrace works,
> there is no separate controller, which has to be enabled, etc.
> 
> Patches (1), (2) and (3) are some preparational work, patch (4) contains
> the implementation, patch (5) is a small cgroup kselftest fix,
> patch (6) covers freezer adds 6 new kselftests to cover the freezer
> functionality. Patchse (7) and (8) adding tracing points to simplify
> the debugging process. Patch (9) adds corresponding docs.

All patches applied to cgroup/for-5.2 w/ Oleg's
No-objection-from-me-by added to (4).

Thanks.

-- 
tejun
