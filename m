From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 2/2] memcg, oom: Clarify some oom dump messages
Date: Tue, 31 Jul 2012 20:55:01 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1207312052070.20073@chino.kir.corp.google.com>
References: <1343146160-15012-1-git-send-email-handai.szj@taobao.com> <1343146334-15161-1-git-send-email-handai.szj@taobao.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=dmHXdvINuDIUO8AvKv5AgNzCTHz8/3bIkuOjL/woRfY=;
        b=jM390Ih1gNvUBii0Oy1Y4TGOcXOrgM4l8lfqE8KU1R7TXnx3dsqQAdZgk+1WeopcZb
         s5IEIVp6Ug0WAfACBodHU3P1JhLHg3Ii0G1lCni/KTJPBlxEaplrZdbb4xIktKuLEnfN
         sfrUl7NrCbXcb3FsRRQzQIMIzoMdQvt+iOn1fE5j5pNM6khgB1WBOUZY2a9pwJpTvF+e
         o+zV1SCI6XH1FuWNpAwWvuBkZEvrmvpdBLG9Utl+42RuipB5PzSR63dkYELHmpWEVFa+
         UMKlkriPL+B36TgAaqnsu7DYACfxi8qRB/rv5yVN2cKWJk5E7OeMm7swQ9j6pYEayGlW
         +zxA==
In-Reply-To: <1343146334-15161-1-git-send-email-handai.szj@taobao.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sha Zhengju <handai.szj@gmail.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>, kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org, mhocko@suse.cz, gthelen@google.com, hannes@cmpxchg.org

On Wed, 25 Jul 2012, Sha Zhengju wrote:

> From: Sha Zhengju <handai.szj@taobao.com>
> 
> Revise some oom dump messages to avoid misleading admin.
> 

The only place the oom killer emits information on what it does via the 
kernel log so changing this has the potential for messing up a number of 
scripts that people are using for parsing it (this would break some of our 
log scraping code, for instance).

This adds nothing except a bogus message that is emitted when 
select_bad_process() races with oom_kill_process() and no kill occurs 
because all threads of the selected process have detached their mm.

Nack.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
