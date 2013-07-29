From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: Re: [patch 4/6] x86: finish user fault error path with fatal signal
Date: Mon, 29 Jul 2013 15:01:00 -0400
Message-ID: <51F6BBEC.5070203@gmail.com>
References: <1374791138-15665-1-git-send-email-hannes@cmpxchg.org> <1374791138-15665-5-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=A0VzFuzOBY+YhBE4PC7IYTtRjmwOGAVbIZ80owndUA0=;
        b=ues2QlokxMT1GEleZVj0NukE43EZ+fSN29xJarW1k2wi8tTMFy/aFYf1ucIfM+WJFE
         39jjgGbyzaKrifTm4EfwGK/EeCJ1ZxBL3ke0d2sjjmT7UoPCkCI8RzNnx4aG166r0g88
         XHNBP6Edc84pAZm/XSAsYOgs8nAhGIZ1/uesoWpeFMBUMNJUFnW6L/57nmkM87zf1Dss
         WLlL+aEd34xAUHmIkTjhqxpjPjN2MuHS8s4vLI0MlRqxR3sosvmeU+SfVzX0Ql/jbvqR
         PSjidM+3xICmvEDDa7jv2O6wBaM7L/jYU+ueJTbo+XeSfWek8NKsKLlKAwNe845qrTLZ
         I57g==
In-Reply-To: <1374791138-15665-5-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, azurIt <azurit@pobox.sk>, linux-mm@kvack.org, cgroups@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, kosaki.motohiro@gmail.com

(7/25/13 6:25 PM), Johannes Weiner wrote:
> The x86 fault handler bails in the middle of error handling when the
> task has a fatal signal pending.  For a subsequent patch this is a
> problem in OOM situations because it relies on
> pagefault_out_of_memory() being called even when the task has been
> killed, to perform proper per-task OOM state unwinding.
> 
> Shortcutting the fault like this is a rather minor optimization that
> saves a few instructions in rare cases.  Just remove it for
> user-triggered faults.
> 
> Use the opportunity to split the fault retry handling from actual
> fault errors and add locking documentation that reads suprisingly
> similar to ARM's.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
