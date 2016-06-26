From: Topi Miettinen <toiwoton@gmail.com>
Subject: Re: [PATCH] capabilities: add capability cgroup controller
Date: Sun, 26 Jun 2016 19:14:00 +0000
Message-ID: <47890d79-0891-dd13-4f60-e7e5f1f3fed3@gmail.com>
References: <1466694434-1420-1-git-send-email-toiwoton@gmail.com>
 <20160623213819.GP3262@mtj.duckdns.org>
 <53377cda-9afe-dad4-6bbb-26affd64cb3a@gmail.com>
 <20160624154830.GX3262@mtj.duckdns.org>
 <20160624155916.GA8759@mail.hallyn.com>
 <20160624163527.GZ3262@mtj.duckdns.org>
 <20160624165910.GA9675@mail.hallyn.com>
 <20160624172447.GA3262@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=subject:to:references:cc:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=wsB2xQReEkUlDKE74GLoSpbVfmyLfPhy7P7IrvWcy8o=;
        b=xL3mkkrmLu6CRi0lFo74kNAgPvPUVqwBf4lbLr1XC0Aan+z1fl6nBd2nD1Y75z4uyj
         XcPcHTrNX2xAQKk0XXXC38eokHSAHrmCuSCD/4x9lOVLX+9lbl0qTAhFm3bMKIdTjUYD
         oIA9/1r/E6qWFwEWYpb+lwB38u/A/4CKQsuz7SZdYu3x8fiin2k5pVLCEZ+KIuouNkSc
         zHCVGHuCwebNJBU5rGYG5qtVEQKSn3ClbwY52XE3xf6PTpxXv60C3ZwUou7xhjlpF06Q
         /y4C/rou4xHwJcCa50ak6JUKoTp7C7CFzqIZWM42TEk/zGj9flSO+Zo40YqybZgYFq77
         l4XQ==
In-Reply-To: <20160624172447.GA3262@mtj.duckdns.org>
Sender: owner-linux-security-module@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org, luto@kernel.org, keescook@chromium.org, Jonathan Corbet <corbet@lwn.net>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Serge Hallyn <serge.hallyn@canonical.com>, James Morris <james.l.morris@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, David Howells <dhowells@redhat.com>, David Woodhouse <David.Woodhouse@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Petr Mladek <pmladek@suse.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:CAPABILITIES" <linux-security-module@vger.kernel.org>

On 06/24/16 17:24, Tejun Heo wrote:
> Hello, Serge.
> 
> On Fri, Jun 24, 2016 at 11:59:10AM -0500, Serge E. Hallyn wrote:
>>> Just monitoring is less jarring than implementing security enforcement
>>> via cgroup, but it is still jarring.  What's wrong with recursive
>>> process hierarchy monitoring which is in line with the whole facility
>>> is implemented anyway?
>>
>> As I think Topi pointed out, one shortcoming is that if there is a short-lived
>> child task, using its /proc/self/status is racy.  You might just miss that it
>> ever even existed, let alone that the "application" needed it.
> 
> But the parent can collect whatever its children used.  We already do
> that with other stats.

The parent might be able do it if proc/pid/xyz files are still
accessible after child exit but before its exit status is collected. But
if the parent doesn't do it (and you are not able to change it to do it)
and it collects the exit status without collecting other info, can you
suggest a different way how another process could collect it 100% reliably?

-Topi

> 
> Thanks.
> 

