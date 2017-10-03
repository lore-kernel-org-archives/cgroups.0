From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: Re: crash during new kmem-limited memory cgroup creation if
 kmem_cache has been created when previous memory cgroup were inactive
Date: Tue, 3 Oct 2017 19:09:44 +0300
Message-ID: <20171003160944.ojiek7wtu3cmyow6@esperanza>
References: <0537E873-CE22-4E6D-912A-6C8FDCF85493@intel.com>
 <20171002143244.lrp5nd2rf3lmjsql@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=MIGe0JhWYZtgrX2k93zXfp2Lqv0V2U3uLXzoEiOL2oE=;
        b=XDqS7OcacNWd4XSig7vMfytoQdL7eDzB/oDURtjEwak91gYeNgL1ohue8n+TipCodm
         YCbWh14J5FOBKw2OSvK2bauBc79+LM3GNFatXe0aaiQtLDTH3EA63mskrPmFE81ZchtX
         MQ+QlI1RE1SMNRD+XEpqaDdWZFQEB8CZ64i817f/xR5TKkEwmw0m2hOj6/Dqo7lSdC0T
         BY4cMCQT9+q9VyKVkM1X56cQJyyyEoOvPDstvTDBxYfiA1FT+q08xPMvLIUGlh4aIzvT
         zAkazN4yrXnaSyf58hXgmo82clOLmyipA+P48R/QEzmSLxdDVtkesvfxqWm4Q1xjMuya
         TivA==
Content-Disposition: inline
In-Reply-To: <20171002143244.lrp5nd2rf3lmjsql@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "Faccini, Bruno" <bruno.faccini@intel.com>
Cc: Michal Hocko <mhocko@kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, linux-mm@kvack.org

Hello Bruno,

On Mon, Oct 02, 2017 at 04:32:44PM +0200, Michal Hocko wrote:
> [CC Vldimir and linux-mm]
> 
> On Tue 19-09-17 22:42:37, Faccini, Bruno wrote:
> > The panic thread’s stack looks like :
> > ============================
> > [38212.118675] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> > [38212.120795] IP: [<ffffffff811dbb04>] __memcg_kmem_get_cache+0xe4/0x220

Kernel memory accounting is totally unusable in 3.10, because it lacks
dcache reclaim and there are a lot of implementation bugs. The one you
caught is just one of many that have been fixed since 3.10. That's why
it stayed disabled by default until 4.x.

So IMHO the best you can do if you really want to use kernel memory
accounting is upgrade to 4.x or backport all related patches.

> > and we can easily trigger it when running one of our regression test
> > that is intended to test our software robustness against lack of
> > Kernel memory, by setting very restrictive kmem limit for a memory
> > cgroup where test’s tasks/contexts will be attached during their
> > execution.

Lack of kernel memory typically results in OOM and killing your
software. The fact that it isn't like that in kmemcg-3.10 and you can
easily get ENOMEM, for example, while scanning a directory is actually
a bug, which was fixed in 4.x.

AFAIU you want to test ENOMEM handling paths. Then IMHO you'd better use
some kind of error injection either in userspace or in kernel, e.g. you
might want to take a look at CONFIG_FAILSLAB.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
