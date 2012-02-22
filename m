From: Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 0/7] memcg kernel memory tracking
Date: Wed, 22 Feb 2012 09:08:26 +0200
Message-ID: <CAOJsxLHOM7e2SpFMXrMZf7u5Y59H1eGyPsrKzSj6jyG9KkWsMw@mail.gmail.com>
References: <1329824079-14449-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=PVUQoPQcirmiwCpkAQVoioUCS3fPMFmYBNCH6SMfJQ8=;
        b=ht2JiC0GtiQqllj0+mB+1WDToByXDN2mWGoWn5w26PGEoETVlEsxukiLweXCL+SIY0
         iieCV6ol39ArJO9dLD8jh9PejflR8VV+7Ubf7cbwFU1mEWtxQjdFLBb7BCF+NfzmSdU+
         c2JVRMlVkCUjRB4nsYMKCdpKm8fiwwTPlmLBA=
In-Reply-To: <1329824079-14449-1-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, devel@openvz.org, linux-mm@kvack.org, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>

Hi Glauber,

On Tue, Feb 21, 2012 at 1:34 PM, Glauber Costa <glommer@parallels.com> wrote:
> This is a first structured approach to tracking general kernel
> memory within the memory controller. Please tell me what you think.

I like it! I only skimmed through the SLUB changes but they seemed
reasonable enough. What kind of performance hit are we taking when
memcg configuration option is enabled but the feature is disabled?

                        Pekka

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
