From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 2/2] cpusets,isolcpus: add file to show isolated cpus
 in cpuset
Date: Mon, 2 Mar 2015 12:31:22 -0500
Message-ID: <20150302173122.GO17694@htj.duckdns.org>
References: <1424882288-2910-1-git-send-email-riel@redhat.com>
 <1424882288-2910-3-git-send-email-riel@redhat.com>
 <54EEFE15.3010005@huawei.com>
 <20150226121231.6fcba7e8@annuminas.surriel.com>
 <20150302170116.GJ17694@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=/Se7P2IbBPC3hUQb2E8qR2xVsXlB6a2S9v1CRz24k18=;
        b=c+YCvmYQKuNSZfvh5WzUf/jrmOIm2AwkjDe4r58iF8QTOgXVf9JQKlG6rwSa7KuhZ7
         7WsufUlw5xmcbyvgcT4DmU4dkdGSwMUL4kkOcbJ07NvMj4hOjL1a2jEOTUzzTq3Orv65
         sgnt7Qel/wKhqUh4SuS0ZaYI4I9xT9ti3txXApFHY5aK5hXSHeUWqRh7mMtC78uFRaQM
         kBtBTCoEDFasJFt6qXoc31eGsuSOXR3VBEAXn0PNHwmYCeeySSrxlO0Y1ZR762JqnS5y
         YTqk5WsAu0aUPYRGBqKOteGFJY7Z3RQ8kYLTLMrekSq0ALwgwUuGUlPBMlkV086VUsPF
         0Yug==
Content-Disposition: inline
In-Reply-To: <20150302170116.GJ17694-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Mar 02, 2015 at 12:01:16PM -0500, Tejun Heo wrote:
> Applied 1-2 to cgroup/for-4.1.

Reverted due to build failure.  Looks like UP build is broken.

Thanks.

-- 
tejun
