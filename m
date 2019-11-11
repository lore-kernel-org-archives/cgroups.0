From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH -next] mm/vmscan: fix an undefined behavior for zone id
Date: Mon, 11 Nov 2019 13:14:27 +0000
Message-ID: <20191111131427.GB891635@chrisdown.name>
References: <20191108204407.1435-1-cai@lca.pw>
 <64E60F6F-7582-427B-8DD5-EF97B1656F5A@lca.pw>
 <20191111130516.GA891635@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vSSh3GLhg1vsDC2+/ekTGoEZx+xBL7fSSkyIjDBus0Y=;
        b=Hbv7vTAJaj3aLmwp1G2ep546uZEGDBhi+No53kbAa6wWPB2FUuSzQQNt4SsHuEN8GQ
         HOkbiVLgICe1ia9awIe0L/ZyaHt8V5FNGkmWEjYcJ3MwIay/64IGOcm/mM1XU2XSBZHg
         +NC8P6rEpo8CNdNh8I7JHCXqgbNRUvoRrrLk8=
Content-Disposition: inline
In-Reply-To: <20191111130516.GA891635@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Qian Cai <cai@lca.pw>
Cc: akpm@linux-foundation.org, mhocko@suse.com, hannes@cmpxchg.org, guro@fb.com, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Chris Down writes:
>Ah, I just saw this in my local checkout and thought it was from my 
>changes, until I saw it's also on clean mmots checkout. Thanks for the 
>fixup!

Also, does this mean we should change callers that may pass through 
zone_idx=MAX_NR_ZONES to become MAX_NR_ZONES-1 in a separate commit, then 
remove this interim fixup? I'm worried otherwise we might paper over real 
issues in future.
