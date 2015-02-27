From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 3/2] cpusets,isolcpus: document relationship between
 cpusets & isolcpus
Date: Fri, 27 Feb 2015 13:15:20 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1502271315090.2122@chino.kir.corp.google.com>
References: <1424882288-2910-1-git-send-email-riel@redhat.com> <1424882288-2910-2-git-send-email-riel@redhat.com> <20150227093231.GG21418@twins.programming.kicks-ass.net> <20150227120803.07db15fe@annuminas.surriel.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=bOTXtFR4Jfrso4kRWrSMFZJ+JxHb5TSq75GX4NEb+Qo=;
        b=VwsUaRDeGBFph4NRXFiIK1M8GPXb7usNloRL/TbAkf5rvfC2gAgNMg//Kyq1OuXNWo
         M8XvljS2AJ96u4Gpdt9/yb5x8XAORVoR+90Kj1fM0ZAjXzOOzShFfaW1JNuArp/kHPF5
         coK+6jE30P19hadbPvUOgma/RJK2oBbzvU9C1w6prP1ZAZL9VfFyeSSlf1eP+nfiVvhd
         8K12PjIOca0yx/6B1GgECuUQE4ItXKt0pLgJ0rJAa55HRvcucv21jforC4AI3nFzpJek
         +WoW89ZGewviWz5g+HS/nCZhOA62HAks4FcpcnOTvNN6P4bkNCIdOW5ixoePz0n7raa9
         +Uzg==
In-Reply-To: <20150227120803.07db15fe@annuminas.surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, Clark Williams <williams@redhat.com>, Li Zefan <lizefan@huawei.com>, Ingo Molnar <mingo@redhat.com>, Luiz Capitulino <lcapitulino@redhat.com>, Mike Galbraith <umgwanakikbuti@gmail.com>, cgroups@vger.kernel.org

On Fri, 27 Feb 2015, Rik van Riel wrote:

> Document the subtly changed relationship between cpusets and isolcpus.
> Turns out the old documentation did not quite match the code...
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Suggested-by: Peter Zijlstra <peterz@infradead.org>

Acked-by: David Rientjes <rientjes@google.com>
