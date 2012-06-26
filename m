From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [rfc][patch 2/3] mm, oom: introduce helper function to process
 threads during scan
Date: Tue, 26 Jun 2012 02:05:04 -0400
Message-ID: <CAHGf_=pOvakOtZA9fWRGchgSb8k80O0Y8D-yUrmFWuoQOqkePQ@mail.gmail.com>
References: <alpine.DEB.2.00.1206251846020.24838@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1206251846450.24838@chino.kir.corp.google.com> <4FE92AF9.4050309@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        bh=u2v4ypFOKM8Uz8Lss2JviWSleOzF/LAixwP7jLwjc5o=;
        b=SwSO6JCXmV0t1dkcnn1URXvG2abZYz7sMNWsNXq/6X08SjFzIEKSiLcJhVYP8XuHKP
         tR1BItmcEvPjNglfUhvdD1qWeuM/obinb3feSRZ0s0pjEF9ARsxf0hOARo9U/Di4e1m5
         eDxeTEkBdDTVDjNfuEAe1uo6XvqA7AH4DpkiyFeKFKs9Ma96LTwHmtkXfkj+nkxkiWzO
         cwAeGAvJxm274MfnM7Q16nUCiU3k8aQ8NFZqA/t2yhwltdkWSn4I1hF65oVHwSMXH6Ix
         mB6P70FRqkSYiMxtSaQeU+mwd89Jm4J3q+8vDJzfnXk4lCLd7YWoziYUEX69BMOFNPOG
         YgMg==
In-Reply-To: <4FE92AF9.4050309@jp.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org

On Mon, Jun 25, 2012 at 11:22 PM, Kamezawa Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> (2012/06/26 10:47), David Rientjes wrote:
>>
>> This patch introduces a helper function to process each thread during th=
e
>> iteration over the tasklist. =A0A new return type, enum oom_scan_t, is
>> defined to determine the future behavior of the iteration:
>>
>> =A0- OOM_SCAN_OK: continue scanning the thread and find its badness,
>>
>> =A0- OOM_SCAN_CONTINUE: do not consider this thread for oom kill, it's
>> =A0 =A0ineligible,
>>
>> =A0- OOM_SCAN_ABORT: abort the iteration and return, or
>>
>> =A0- OOM_SCAN_SELECT: always select this thread with the highest badness
>> =A0 =A0possible.
>>
>> There is no functional change with this patch. =A0This new helper functi=
on
>> will be used in the next patch in the memory controller.
>>
>> Signed-off-by: David Rientjes <rientjes@google.com>
>
>
> I like this.
>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
