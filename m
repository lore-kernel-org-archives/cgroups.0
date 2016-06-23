From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] capabilities: add capability cgroup controller
Date: Thu, 23 Jun 2016 17:38:19 -0400
Message-ID: <20160623213819.GP3262@mtj.duckdns.org>
References: <1466694434-1420-1-git-send-email-toiwoton@gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KG3Y36jQFSVKIe+5RMabtdGQTu/XTv2PK9hj2hB8Qqk=;
        b=A3a/IHJiNWOKGPP7i2VLHm7FI2cyT3ohH6bWXb9IfwRUKVx1B5ilKQAe/YUn2LgDCW
         0huRmIwYvSvTrYjrbMBfByvbo/t6iaPrVKDFWM3goAy7jgjeJ1axddG1BK7PnHfPg1Oq
         7ESpLLzV3OQ2tBTP7c8vGw1eOYhbty05oMA+6vigrnBmOKHNZEvuteBGEWb8HOYGpb1v
         WIoCNOgdBrAaa/iUN1YqB1ABFxbJEFdkCWafcbqxY7qbTFBpf9p4T0RwqP9b5C6UZgIi
         zbb+h3GwwASBPGjZCmm4Dpbk09GtF0LZuwLtJ69nE73IaRlu0N60AAbjrCRmCUC1BZAa
         J12g==
Content-Disposition: inline
In-Reply-To: <1466694434-1420-1-git-send-email-toiwoton@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Topi Miettinen <toiwoton@gmail.com>
Cc: linux-kernel@vger.kernel.org, luto@kernel.org, serge@hallyn.com, keescook@chromium.org, Jonathan Corbet <corbet@lwn.net>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Serge Hallyn <serge.hallyn@canonical.com>, James Morris <james.l.morris@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, David Howells <dhowells@redhat.com>, David Woodhouse <David.Woodhouse@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Petr Mladek <pmladek@suse.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:CAPABILITIES" <linux-security-module@vger.kernel.org>

Hello,

On Thu, Jun 23, 2016 at 06:07:10PM +0300, Topi Miettinen wrote:
> There are many basic ways to control processes, including capabilities,
> cgroups and resource limits. However, there are far fewer ways to find
> out useful values for the limits, except blind trial and error.
> 
> Currently, there is no way to know which capabilities are actually used.
> Even the source code is only implicit, in-depth knowledge of each
> capability must be used when analyzing a program to judge which
> capabilities the program will exercise.
> 
> Add a new cgroup controller for monitoring of capabilities
> in the cgroup.
> 
> Test case demonstrating basic capability monitoring and how the
> capabilities are combined at next level (boot to rdshell):

This doesn't have anything to do with resource control and I don't
think it's a good idea to add arbitrary monitoring mechanisms to
cgroup just because it's easy to add interface there.  Given that
capabilities are inherited and modified through the process hierarchy,
shouldn't this be part of that?

Thanks.

-- 
tejun
