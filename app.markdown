---
layout: page
linkName: Apps
title: Apps
permalink: /app/
headimage: https://ugc.hitv.com/32/230724013151149f7e1afc60a2a26670c1d25c3ed22f/ESCpEa0.jpeg
---

<div class="home">

  <!--h1 class="page-heading">应用App</h1-->
  <ul class="blog-list app-list">
    {% for post in site.posts %}
      {% if post.categories contains "app" %}
      <li>
        <a class="post-list-link" href="{{ post.url | prepend: site.baseurl }}">
            <div class="post-list-show-image">
              <div class="post-list-show-image-image" bg="{{ post.appicon }}">
              </div>
            </div>
            <div class="post-list-title">{{ post.title }}</div>
            <div class="post-list-description">{{ post.description }}</div>
        </a>
        <!--div class="post-list-info">
        <a class="post-app-link link-button" href="{{ post.appstorelink }}">AppStore</a>
        </div-->
      </li>
      {% endif %}
    {% endfor %}

  </ul>
<!--
    <h1 class="page-heading">福利时间</h1>

  <p>  10个超级密码AppStore兑换码 ( 2023-8-10  )</p>
  <div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>

  9RMNXHTF3FXW
  HL9L97PEK396
  R446RFLT3AE4
  AXX9AW4MPXWH
  RJK7J4PWYK9X
  H44LMAPLA7JT
  46LELNL47EHH
  33AK999RK47P
  L6M4RREHEPTK
  A3T6NWAXXP9E
  </code></pre></div></div>
-->
    <h1 class="page-heading">Dev Log</h1>
    <ul class="blog-list app-update-list">

            <li>
                  <div class="post-list-title">GPWZW.COM<span class="post-list-version">V26.1.1</span></div>
                  <div class="post-list-description">
                  <ol>
                  <li>New Site</li>
                  </ol>
                  </div>
                  <div class="post-list-info">
                    <span class="post-category post-category-app"></span>
                    <span class="post-meta">2026-1-1</span>
                  </div>
            </li>
          <li>
                <div class="post-list-start">
                </div>
          </li>
    </ul>

</div>
<style>
  .page-content:before {
    background-image: url('{{ page.headimage }}');
    display: block;
  }

  .page-content:after {
    display: block;
  }
</style>

<script>
  // 检查浏览器是否支持webp
  function isSupportWebP() {
    return document.createElement('canvas').toDataURL('image/webp').indexOf('data:image/webp') == 0;
  }

  // 如果支持webp,则在img标签src上添加后缀
  const imgList = document.querySelectorAll('.post-list-show-image-image');
 var i=0;
  if (isSupportWebP()) {
    imgList.forEach(img => {
      let src = img.getAttribute('bg');
      img.style.backgroundImage = "url('" + src + "')";
      setTimeout(function(){img.style.opacity=1;},100+300*i);
      i++;
    });
  } else {
    imgList.forEach(img => {
      let src = img.getAttribute('bg');
      img.style.backgroundImage = "url('" + src + "')";
      setTimeout(function(){img.style.opacity=1;},300+300*i);
      i++;
    });

  }
</script>
