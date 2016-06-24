From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] capabilities: add capability cgroup controller
Date: Fri, 24 Jun 2016 13:24:47 -0400
Message-ID: <20160624172447.GA3262@mtj.duckdns.org>
References: <1466694434-1420-1-git-send-email-toiwoton@gmail.com>
 <20160623213819.GP3262@mtj.duckdns.org>
 <53377cda-9afe-dad4-6bbb-26affd64cb3a@gmail.com>
 <20160624154830.GX3262@mtj.duckdns.org>
 <20160624155916.GA8759@mail.hallyn.com>
 <20160624163527.GZ3262@mtj.duckdns.org>
 <20160624165910.GA9675@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nb9SS21on7P8obYoKkJOVRFESo6s7sZzSWWEMgg3AsA=;
        b=UHAbgKeu2K3QPnTFeV9T6lQ3jDiGdS+CJJ3Tw+VFyDktl/CdBvjzGu9uO9EZv+bzXC
         gpBCIptS5fSJ9pBAApFHYb9wVId6a1PcjXALBTWyOt63YYURQpobENhhWcF62DA0eyMy
         qgYypvFa/QRWNtIBj1EDgONAyrjSWrBA+yClzmZ4kkJXj79ce1ZNwnMBV+A1Hz9bbK76
         vEwvQABIminiG/gNyfC6HW2Fm1A6OwpNPziPQtTH5EN2xgRQrJobdte0wsasFhyabUAG
         KwPdGl5mcOLOdXqGjCQnNQteiqNwjwum8llVZsIG2biVcQn6NEXbqaVsfEMP4iyiIxXK
         rbyQ==
Content-Disposition: inline
In-Reply-To: <20160624165910.GA9675@mail.hallyn.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Topi Miettinen <toiwoton@gmail.com>, linux-kernel@vger.kernel.org, luto@kernel.org, keescook@chromium.org, Jonathan Corbet <corbet@lwn.net>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Serge Hallyn <serge.hallyn@canonical.com>, James Morris <james.l.morris@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, David Howells <dhowells@redhat.com>, David Woodhouse <David.Woodhouse@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Petr Mladek <pmladek@suse.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:CAPABILITIES" <linux-security-module@vger.kernel.org>

Hello, Serge.

On Fri, Jun 24, 2016 at 11:59:10AM -0500, Serge E. Hallyn wrote:
> > Just monitoring is less jarring than implementing security enforcement
> > via cgroup, but it is still jarring.  What's wrong with recursive
> > process hierarchy monitoring which is in line with the whole facility
> > is implemented anyway?
> 
> As I think Topi pointed out, one shortcoming is that if there is a short-lived
> child task, using its /proc/self/status is racy.  You might just miss that it
> ever even existed, let alone that the "application" needed it.

But the parent can collect whatever its children used.  We already do
that with other stats.

Thanks.

-- 
tejun
