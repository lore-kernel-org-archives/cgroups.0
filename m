From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC 4/5] drm/amdgpu: Add accounting of command submission
 via DRM cgroup
Date: Wed, 21 Nov 2018 11:03:28 +0100
Message-ID: <56833f60-1636-d149-c9b0-c021a6ad99d1@gmail.com>
References: <20181120185814.13362-1-Kenny.Ho@amd.com>
 <20181120185814.13362-5-Kenny.Ho@amd.com> <87r2ff79he.fsf@anholt.net>
Reply-To: christian.koenig-5C7GfCeVMHo@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1817031157=="
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <87r2ff79he.fsf-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>
Content-Language: en-US
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>, Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org

This is a multi-part message in MIME format.
--===============1817031157==
Content-Type: multipart/alternative;
 boundary="------------A9E74F24E04BBDB26A778365"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------A9E74F24E04BBDB26A778365
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 20.11.18 um 21:57 schrieb Eric Anholt:
> Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org> writes:
>
>> Account for the number of command submitted to amdgpu by type on a per
>> cgroup basis, for the purpose of profiling/monitoring applications.
> For profiling other drivers, I've used perf tracepoints, which let you
> get useful timelines of multiple events in the driver.  Have you made
> use of this stat for productive profiling?

Yes, but this is not related to profiling at all.

What we want to do is to limit the resource usage of processes.

Regards,
Christian.

>
> _______________________________________________
> amd-gfx mailing list
> amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
> https://lists.freedesktop.org/mailman/listinfo/amd-gfx


--------------A9E74F24E04BBDB26A778365
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 7bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    <div class="moz-cite-prefix">Am 20.11.18 um 21:57 schrieb Eric
      Anholt:<br>
    </div>
    <blockquote type="cite" cite="mid:87r2ff79he.fsf-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org">
      <pre class="moz-quote-pre" wrap="">Kenny Ho <a class="moz-txt-link-rfc2396E" href="mailto:Kenny.Ho-5C7GfCeVMHo@public.gmane.org">&lt;Kenny.Ho-5C7GfCeVMHo@public.gmane.org&gt;</a> writes:

</pre>
      <blockquote type="cite">
        <pre class="moz-quote-pre" wrap="">Account for the number of command submitted to amdgpu by type on a per
cgroup basis, for the purpose of profiling/monitoring applications.
</pre>
      </blockquote>
      <pre class="moz-quote-pre" wrap="">
For profiling other drivers, I've used perf tracepoints, which let you
get useful timelines of multiple events in the driver.  Have you made
use of this stat for productive profiling?
</pre>
    </blockquote>
    <br>
    Yes, but this is not related to profiling at all.<br>
    <br>
    What we want to do is to limit the resource usage of processes.<br>
    <br>
    Regards,<br>
    Christian.<br>
    <br>
    <blockquote type="cite" cite="mid:87r2ff79he.fsf-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org"><br>
      <fieldset class="mimeAttachmentHeader"></fieldset>
      <pre class="moz-quote-pre" wrap="">_______________________________________________
amd-gfx mailing list
<a class="moz-txt-link-abbreviated" href="mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org">amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org</a>
<a class="moz-txt-link-freetext" href="https://lists.freedesktop.org/mailman/listinfo/amd-gfx">https://lists.freedesktop.org/mailman/listinfo/amd-gfx</a>
</pre>
    </blockquote>
    <br>
  </body>
</html>

--------------A9E74F24E04BBDB26A778365--

--===============1817031157==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KYW1kLWdmeCBt
YWlsaW5nIGxpc3QKYW1kLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5m
cmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9hbWQtZ2Z4Cg==

--===============1817031157==--
