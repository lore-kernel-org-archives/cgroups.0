From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [GIT PULL] cgroup fixes for v3.17-rc4
Date: Sun, 7 Sep 2014 20:17:11 -0700
Message-ID: <CA+55aFw+L1EUDEmAATDtGj_ngHos842jHLddAszboRy4b0pn2A@mail.gmail.com>
References: <20140908012025.GF5061@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=sBfV0d1lYoN+WNSEPK3zrX0GYa/Btaw2kJTpcwyhc0M=;
        b=rP8m055hQJ04ihktrLwIOaCCjsEtDt2D35OEBGF9EgpDzJ0tmamKvcP7demnMopMNy
         Bah0U1D1fBO5BL8ABXfglnooumcMYnBvMOQc7Ppl85ckjDbYL1ougGb1lzKP+K7p+d0h
         kZgWrAGi2Ttu6juCnmdDyVcSTsxmXExs9xwAhPYvjNfX1JwPFOR1kHQO/RFCN+OD88jZ
         DeCy6SrnE4yYpuerTN3syxM7BK/cYAHh0HL7VPGtazu63Wgx7RkyN+LIZAC52yWEDg6A
         5sqq9h163WL/7wFTybWaJnETU6UP/XjlkxdLhpr6GB7cGRmm3fMpatvSOjLXyuFnIQB6
         JumA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=sBfV0d1lYoN+WNSEPK3zrX0GYa/Btaw2kJTpcwyhc0M=;
        b=Tze68UBspxBxToCyDpIjVDRX6G53974Fhv8hUdQCmyBItrcYvfFpxM1LL7Jw3oMXOu
         WQJ1sMH0aVbyPTC7/Vx9xu8mTM1a8wXTNNRFgccEOSVtjfDMWY1GYn8q+2rhJLMx+QaS
         6SZ/ee2VRtGf8I1eTbKZ6gwy8HziKXhQZGYu4=
In-Reply-To: <20140908012025.GF5061-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, Sep 7, 2014 at 6:20 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
>                   While this is a userland visible
> behavior change, given the craziness of allowing '\n' and its
> implications, I believe the change is justified.

Tejun, absolutely nothing "justifies" things if they break. Not "bad
design", not "craziness". Even security issues should be worked around
without breaking, if at all possible,

However, "userland visible" is only relevant _if_ things break.
Presumably nobody actually uses '\n' in a cgroup name. And if nothing
breaks, you don't need the excuses.

In other words, I'll happily pull this, but your excuses for it are
wrong-headed. There is no "crazyness justifies this". That's crap. But
the argument of "nobody does this, so let's fix it before anybody
_starts_ doing it" is perfectly valid - with the deep and implicit
understanding that if it turns out somebody *does* do it, the change
gets reverted asap.

People need to understand this. "Theoretical ABI breakage" is entirely
irrelevant. Nobody cares. But any _actual_ ABI breakage is a complete
no-no.

So next time you realize "ok, this could break things", don't make
excuses. Look for alternatives (maybe the name can be escaped, for
example), or take the approach of "let's hopw nobody notices".

None of this "the interface is crazy, so we can change it".  Because
that is pure and utter BS. Whether the interface is crazy or not is
*entirely* irrelevant to whether it can be changed or not. The only
thing that matters is whether people actually _trigger_ the issue you
have in reality, not whether the issue is crazy.

See the difference?

                 Linus
