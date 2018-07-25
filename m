From: David Rientjes <rientjes@google.com>
Subject: Re: cgroups iptables-restor: vmalloc: allocation failure
Date: Wed, 25 Jul 2018 12:42:58 -0700 (PDT)
Message-ID: <alpine.DEB.2.21.1807251241380.201050@chino.kir.corp.google.com>
References: <a1a4eb7c-e85c-dc6d-cfac-6d40af302182@icdsoft.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=Rr0DGf258LtpsVligxZ3mbAGceSMKOhw9gr7Ekbzz6o=;
        b=WUxnOqImF5IuqKhi7lwDk2FGjpVzW3TULS4dToSIyZn358xW8fEBsGii/UkXFmp1jR
         al351D5dIdd7Fgzr7r5MSBvvmR98KroPjojWms2rqOLKjKSIIsMbBUvoLz8qRzcaaeFt
         keBwU1vDqEor/noqllou82uY1lA+UvgfxgKKeH8/Ck4UwCvdZPMEPcqhKC3Yfirlx+BM
         qNqW0G+BrCiKifPmbEJX8xA6XEwmGzffaIt38bfSDHDpeEMja+IJHu/pjPg9baNe9xNs
         c3oX218YD7+FcBwxZSq8PzZcobKcw2pjyzlhm2Zv8O6hF/f5tldDxkd4aVF35wDHPfGE
         gqeA==
In-Reply-To: <a1a4eb7c-e85c-dc6d-cfac-6d40af302182@icdsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Georgi Nikolov <gnikolov@icdsoft.com>
Cc: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 25 Jul 2018, Georgi Nikolov wrote:

> Hello,
> 
> I posted a kernel bug https://bugzilla.kernel.org/show_bug.cgi?id=200651 and
> i hope this is the correct place to discuss this.
> 

Could you post the full allocation failure from the kernel log?  It's not 
possible to vmalloc any additional memory due to the memory pressure, so 
this is expected to fail but I'm curious as to the actual allocation that 
is triggering it.
